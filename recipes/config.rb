#
# Cookbook Name:: elk-hardis
# Recipe:: config
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


#################################
#GRAFANA
#################################
url_api_grafana = 'http://admin:admin@localhost:3000/api/datasources'

elasticsearch_json_data = '{\"name\":\"Elasticsearch\",
                \"type\":\"elasticsearch\",
                \"url\":\"http://localhost:9200\",
                \"access\":\"proxy\",
                \"jsonData\":{\"timeField\":\"@timestamp\",\"interval\":\"Daily\"},
                \"database\":\"[logstash-]YYYY.MM.DD\"}'

collectd_json_data = '{\"name\":\"Collectd\",
                \"type\":\"influxdb\",
                \"url\":\"http://localhost:8086\",
                \"access\":\"proxy\",
                \"jsonData\":{},
                \"database\":\"collectd\"}'
				
telegraf_json_data = '{\"name\":\"Telegraf\",
                \"type\":\"influxdb\",
                \"url\":\"http://localhost:8086\",
                \"access\":\"proxy\",
                \"jsonData\":{},
                \"database\":\"telegraf\"}'


execute 'Grafana : add elasticsearch datasource' do
   command "curl #{url_api_grafana} -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*'  -H 'Referer: http://localhost:3000/datasources/new' --data-binary \"#{elasticsearch_json_data}\" --compressed"
   retries 3
   retry_delay 5
end

execute 'Grafana : add influxdb collectd datasource' do
   command "curl #{url_api_grafana} -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*'  -H 'Referer: http://localhost:3000/datasources/new' --data-binary \"#{collectd_json_data}\" --compressed"
end

execute 'Grafana : add influxdb telegraf datasource' do
   command "curl #{url_api_grafana} -H 'Content-Type: application/json;charset=UTF-8' -H 'Accept: application/json, text/plain, */*'  -H 'Referer: http://localhost:3000/datasources/new' --data-binary \"#{telegraf_json_data}\" --compressed"
end


execute 'Grafana : add grafana-clock-panel' do
   command "grafana-cli plugins install grafana-clock-panel"
end



#################################
#KIBANA
#################################

bash 'kibana datasource' do
  code <<-EOH
curl http://localhost:5601/elasticsearch/.kibana/index-pattern/logstash-*?op_type=create  -H 'kbn-version: 4.6.1' --data-binary '{"title":"logstash-*","timeFieldName":"@timestamp"}' 
curl http://localhost:5601/elasticsearch/.kibana/config/4.6.1/_update -H 'kbn-version: 4.6.1' --data-binary '{"doc":{"buildNum":10146,"defaultIndex":"logstash-*"}}' --compressed
    EOH
	retries 3
	retry_delay 5
end


#################################
#INFLUXDB
#################################


execute 'add retention policy in influxdb' do
    command 'influx -execute "CREATE RETENTION POLICY three_days_only ON collectd DURATION 5d REPLICATION 1 DEFAULT"'
	retries 3
	retry_delay 5
end
