# json.object_type klass.to_s
# jsons.array error_messages do |error|
#     json.attribute error.key
# end

json.errors do
    json.set!(@klass.model_name.param_key) { @errors.full_messages }
end