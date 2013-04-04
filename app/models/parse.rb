class Parse

    require 'csv'

    def self.hits(study_id, file, clear=false)

        if clear
            Hit.includes({:deployment => :study}).where({:study_id => study_id}).destroy_all
        end

        first_line = File.open(file, &:readline)
        if first_line =~ /Date and Time (UTC)/ 
            return Parse.vemco_vue_hits(study, file)
        elsif first_line =~ /event_date/
            Parser.cbibs_realtime_hits(study, file)
        end
    end


    def self.vemco_vue_hits(study_id, file)
        CSV.foreach(file, {:headers => true}) do |row|
            split_codes = row["Transmitter"].split("-")
            code_space = split_codes.first(2).join("-")
            code = split_codes.last
            tag = Tag.find_by_code_and_code_space(code, code_space)

            id_split = row["Receiver"].split("-")
            model = id_split.first.downcase
            serial = id_split.last
            unless model.nil? || serial.nil?
                Deployment.find_or_initialize_by_model_and_serial(model, serial)
            end
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
        if first_line =~ /TAG_CODESPACE_AND_TAG_ID/
            return Parser.act_tags(study, file)
        end

    end

    def self.act_tags(study_id, file)
        CSV.foreach(file, {:headers => true}) do |row|
            code_space = row["TAG_CODESPACE_AND_TAG_ID"].split("-").first(2).join("-") rescue nil
            if code_space.nil? || code_space.blank?
                puts "Could not resolve code_space from: #{row}"
                next
            end
            t = Tag.find_or_initialize_by_code_and_code_space(code_space, row["TAG_ID"])
            t.attributes =
            {
                :model => (row["TAG_MODEL"].downcase rescue nil),
                :type => (row["TAG_TYPE"].downcase rescue nil),
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
                    :common_name => (row["COMMON_NAME"].downcase rescue nil),
                    :scientific_name => (row["SCIENTIFIC_NAME"].downcase rescue nil),
                    :description => row["COMMENTS"],
                    :release_location => row["RELEASE_LOCATION"],
                    :implant_type => (row["TAG_IMPLANT_TYPE"].downcase rescue nil),
                    :lifespan => (lifespan + " days" rescue nil),
                    :expiration_date => expiration_date
                }

                td.save
            end
        end
    end


    def self.receivers(study, file)
    end


end