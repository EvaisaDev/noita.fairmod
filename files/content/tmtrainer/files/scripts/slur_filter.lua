local slurs = {
	"beaners",
	"beaner",
	"bimbo",
	"coon",
	"coons",
	"cunt",
	"cunts",
	"darkie",
	"darkies",
	"fag",
	"fags",
	"faggot",
	"faggots",
	"hooker",
	"kike",
	"kikes",
	"nazi",
	"nazis",
	"neonazi",
	"neonazis",
	"negro",
	"negros",
	"nigga",
	"niggas",
	"nigger",
	"niggers",
	"paki",
	"pakis",
	"raghead",
	"ragheads",
	"shemale",
	"shemales",
	"slut",
	"sluts",
	"spic",
	"spics",
	"swastika",
	"towelhead",
	"towelheads",
	"tranny",
	"trannys",
	"trannies",
	"twink",
	"twinks",
	"wetback",
	"wetbacks"
}

local module = {}

module.contains_slur = function(str)
	for _, slur in ipairs(slurs) do
		if string.find(str, slur) then
			return true
		end
	end
	return false
end

return module