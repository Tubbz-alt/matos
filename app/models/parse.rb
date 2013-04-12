class Parse

    require 'csv'

    def self.hits(study_id, file, clear=false)

        if clear
            Hit.includes(:receiver_deployment).where("receiver_deployments.study_id = %s" % study_id).destroy_all
        end

        first_line = File.open(file, &:readline)
        ActiveRecord::Base.transaction do
            if first_line =~ /Date and Time\ \(UTC\)/ 
                return Parse.vemco_vue_hits(study_id, file)
            elsif first_line =~ /event_date/
                return Parse.cbibs_realtime_hits(study_id, file)
            end
        end
    end


    def self.vemco_vue_hits(study_id, file)

        errors = []
        receivers = 0
        receiver_deployments = 0
        hits = 0

        study = Study.find(study_id)

        CSV.foreach(file, {:headers => true}) do |row|
            begin
                lat = row["Latitude"].gsub("+","")
                lon = row["Longitude"]

                location = "POINT(%s %s)" % [lon, lat]

                hit_datetime = DateTime.parse(row["Date and Time (UTC)"] + " UTC")

                split_codes = row["Transmitter"].split("-")
                code_space = split_codes.first(2).join("-")
                code = split_codes.last
                # Create the tag as a holder so other people can match it
                tag = Tag.find_or_create_by_code_and_code_space(code, code_space)
                tag_deployment = TagDeployment.includes(:tag).where(:tag_id => tag.id).where("release_date <= '#{hit_datetime}'").order("release_date DESC").first rescue nil

                id_split = row["Receiver"].split("-")
                model = id_split.first.downcase
                serial = id_split.last.downcase

                receiver = nil
                receiver_deployment = nil
                unless model.nil? || serial.nil?
                    receiver = Receiver.find_by_model_and_serial(model, serial)
                    if receiver.nil?
                        receiver = Receiver.new({ :model => model, :serial => serial })
                        begin
                            receiver.save!
                            receivers += 1
                        rescue Exception => e
                            errors << "#{e.message} : #{row}"
                            next
                        end
                    end
                    receiver_deployment = ReceiverDeployment.find_or_initialize_by_receiver_id_and_name_and_location(receiver.id, row["Station Name"], location)
                    if receiver_deployment.otn_array.nil?
                        # Use the Study's default OTN_ARRAY
                        receiver_deployment.otn_array = OtnArray.find_by_code(study.code) rescue nil
                    end
                    receiver_deployment.study_id = study_id
                    begin
                        receiver_deployment.save!
                        receiver_deployments += 1
                    rescue Exception => e
                        errors << "#{e.message} : #{row}"
                        next
                    end
                end

                h = Hit.new({
                    :tag_deployment => tag_deployment,
                    :tag_code => split_codes.join("-"),
                    :receiver_deployment => receiver_deployment,
                    :receiver_serial => serial,
                    :receiver_model => model,
                    :location => location,
                    :time => hit_datetime
                })
                begin
                    h.save!
                    hits += 1
                rescue Exception => e
                    errors << "#{e.message} : #{row}"
                end
            rescue Exception => e
                errors << "#{e.message} : #{row}"
            end
        end

        return { "receivers" => receivers, "receiver_deployments" => receiver_deployments, "hits" => hits, "errors" => errors }
    end

    def self.cbibs_realtime_hits(study_id, file)
        CSV.foreach(file, {:headers => true}) do |row|

        end
    end


    def self.tags(study_id, file, clear=false)

        if clear
            tag_deployments = TagDeployment.includes(:study).includes(:tag).where({:study_id => study_id})
            tags = tag_deployments.map(&:tag)
            tag_deployments.destroy_all
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

        errors = []
        tags = 0
        tag_deployments = 0

        CSV.foreach(file, {:headers => true}) do |row|
            begin
                code_space = row["TAG_CODESPACE_AND_TAG_ID"].split("-").first(2).join("-") rescue nil
                if code_space.nil? || code_space.blank?
                    errors << "Could not resolve code_space from : #{row}"
                    next
                end
                t = Tag.find_or_initialize_by_code_and_code_space(row["TAG_ID"], code_space)
                t.attributes =
                {
                    :model => (row["TAG_MODEL"] rescue nil),
                    :type => (row["TAG_TYPE"] rescue nil),
                }
                begin
                    t.save!
                    tags += 1
                rescue Exception => e
                    errors << "#{e.message} : #{row}"
                    next
                end

                release_date = DateTime.strptime(row["UTC_RELEASE_DATE_TIME"] + " UTC", "%m/%d/%Y %Z") rescue nil
                if release_date.nil?
                    errors << "Could not resolve release_date : #{row}"
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

                begin
                    td.save!
                    tag_deployments += 1
                rescue Exception => e
                    errors << "#{e.message} : #{row}"
                end

            rescue Exception => e
                errors << "#{e.message} : #{row}"
            end
        end

        return { :tags => tags, :tag_deployments => tag_deployments, :errors => errors }
    end


    def self.receivers(study_id, file)
        ActiveRecord::Base.transaction do
        end
    end


end