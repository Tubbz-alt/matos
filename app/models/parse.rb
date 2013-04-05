class Parse

    require 'csv'

    def self.hits(study_id, file, clear=false)

        if clear
            Hit.includes(:receiver_deployment).where("receiver_deployments.study_id = %s" % study_id).destroy_all
        end

        first_line = File.open(file, &:readline)
        #ActiveRecord::Base.transaction do
            if first_line =~ /Date and Time\ \(UTC\)/ 
                return Parse.vemco_vue_hits(study_id, file)
            elsif first_line =~ /event_date/
                Parse.cbibs_realtime_hits(study_id, file)
            end
        #end
    end


    def self.vemco_vue_hits(study_id, file)
        CSV.foreach(file, {:headers => true}) do |row|

            lat = row["Latitude"].gsub("+","")
            lon = row["Longitude"]

            location = "POINT(%s %s)" % [lon, lat]

            hit_datetime = DateTime.parse(row["Date and Time (UTC)"] + " UTC")

            split_codes = row["Transmitter"].split("-")
            code_space = split_codes.first(2).join("-")
            code = split_codes.last
            tag = Tag.find_by_code_and_code_space(code, code_space)
            tag_deployment = TagDeployment.includes(:tag).where(:tag_id => tag.id).where("release_date <= '#{hit_datetime}'").order("release_date DESC").first rescue nil

            id_split = row["Receiver"].split("-")
            model = id_split.first.downcase
            serial = id_split.last.downcase

            receiver = nil
            receiver_deployment = nil
            unless model.nil? || serial.nil?
                receiver = Receiver.find_by_model_and_serial(model, serial)
                if receiver.nil?
                    receiver = Receiver.create({ :model => model, :serial => serial })
                end
                receiver_deployment = ReceiverDeployment.find_or_initialize_by_receiver_id_and_name_and_location(receiver.id, row["Station Name"], location)
                if receiver_deployment.otn_array.nil?
                    # Create a dummy OTN array that defaults to the Study.
                    study = Study.find(study_id)
                    receiver_deployment.otn_array = OtnArray.find_by_code(study.code) rescue nil
                end
                receiver_deployment.study_id = study_id
                receiver_deployment.save
            end

            Hit.create({
                :tag_deployment => tag_deployment,
                :tag_code => split_codes.join("-"),
                :receiver_deployment => receiver_deployment,
                :receiver_serial => serial,
                :receiver_model => model,
                :location => location,
                :time => hit_datetime
            })

        end
    end

    def self.cbibs_realtime_hits(study_id, file)
        CSV.foreach(file, {:headers => true}) do |row|

        end
    end


    def self.tags(study_id, file, clear=false)

        if clear
            tag_deployments = TagDeployment.includes(:study).includes(:tag).where({:study_id => study_id})
            tags = tag_deployments.map(&:tag)
            tag_deployments.destory_all
            tags.each { |t| t.destroy if t.tag_deployments.empty? }
        end

        first_line = File.open(file, &:readline)
        ActiveRecord::Base.transaction do
            if first_line =~ /TAG_CODESPACE_AND_TAG_ID/
                return Parse.act_tags(study_id, file)
            end
        end

    end

    def self.act_tags(study_id, file)
        CSV.foreach(file, {:headers => true}) do |row|
            code_space = row["TAG_CODESPACE_AND_TAG_ID"].split("-").first(2).join("-") rescue nil
            if code_space.nil? || code_space.blank?
                puts "Could not resolve code_space from: #{row}"
                next
            end
            t = Tag.find_or_initialize_by_code_and_code_space(row["TAG_ID"], code_space)
            t.attributes =
            {
                :model => (row["TAG_MODEL"] rescue nil),
                :type => (row["TAG_TYPE"] rescue nil),
            }
            if t.save
                release_date = DateTime.strptime(row["UTC_RELEASE_DATE_TIME"] + " UTC", "%m/%d/%Y %Z") rescue nil
                if release_date.nil?
                    puts "Could not resolve release_date from: #{row}"
                    next
                end
                td = TagDeployment.find_or_initialize_by_tag_id_and_release_date(t.id, release_date)

                expiration_date = DateTime.strptime(row["UTC_EXPIRATION_DATE_TIME"] + " UTC","%m/%d/%Y %Z") rescue nil
                lifespan = row["EST_TAG_LIFE"].split(" ")[0].to_i rescue nil
                if expiration_date.nil? and !lifespan.nil?
                    expiration_date = release_date.advance(:days => lifespan)
                end

                td.attributes = 
                {
                    :study_id => study_id,
                    :common_name => row["COMMON_NAME"],
                    :scientific_name => row["SCIENTIFIC_NAME"],
                    :description => row["COMMENTS"],
                    :release_location => row["RELEASE_LOCATION"],
                    :implant_type => row["TAG_IMPLANT_TYPE"],
                    :lifespan => (lifespan + " days" rescue nil),
                    :expiration_date => expiration_date
                }

                td.save
            end
        end
    end


    def self.receivers(study_id, file)
        ActiveRecord::Base.transaction do
        end
    end


end