#warning-ignore:unused_class_variable
const meta := {
	script_name = "core.dictionary.main",
	description = """
		
	"""
}

# Get a given data from a dictionary with position provided as a list
static func get_from_dict(dataDict, mapList: Array):
	for k in mapList:
		if dataDict.has(k):
			dataDict = dataDict[k]
		else:
			return false
	return dataDict

# Set a given data in a dictionary with position provided as a list
static func set_in_dict(dataDict: Dictionary, mapList: Dictionary, value) -> void:
	var dict = mapList
	dict.remove(dict.size() - 1)
	
	for k in dict: 
		dataDict = dataDict[k]
	dataDict[mapList[-1]] = value

static func merge_dict(target: Dictionary, patch: Dictionary) -> void:
	for key in patch:
		if target.has(key):
			var tv = target[key]
			if typeof(tv) == TYPE_DICTIONARY:
				merge_dict(tv, patch[key])
			else:
				target[key] = patch[key]
		else:
			target[key] = patch[key]
 
static func find_all_value(_dict: Dictionary, target):
	for key in _dict.keys():
		#case 1: it is a dictionary but not match the key
		if typeof(_dict[key]) == TYPE_DICTIONARY and key != target:
		    return find_all_value(_dict[key], target)
		#case 2: it is a dictionary but match the key -> put it in result
		elif typeof(_dict[key]) == TYPE_DICTIONARY and key == target:
		    return [_dict[key]] + find_all_value(_dict[key], target)
		#case 3: it is not dictionary and match the key -> put it in result
		elif key == target:
		    return [_dict[key]]
