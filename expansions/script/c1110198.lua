muxu=muxu or {}
local cm=muxu
muxu.loaded_metatable_list={}
function muxu.load_metatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=muxu.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			muxu.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function muxu.check_set(c,setcode,v,f,...) 
	local codet=nil
	if type(c)=="number" then
		codet={c}
	elseif type(c)=="table" then
		codet=c
	elseif type(c)=="userdata" then
		local f=f or Card.GetCode
		codet={f(c)}
	end
	local ncodet={...}
	for i,code in pairs(codet) do
		for i,ncode in pairs(ncodet) do
			if code==ncode then return true end
		end
		local mt=muxu.load_metatable(code)
		if mt and mt["named_with_"..setcode] and (not v or mt["named_with_"..setcode]==v) then return true end
	end
	return false
end
function muxu.check_set_Soul(c)			  --灵曲
	return muxu.check_set(c,"Soul")
end
function muxu.check_set_Border(c)			--交界
	return muxu.check_set(c,"Border")
end
function muxu.check_set_Legend(c)			--秘谈
	return muxu.check_set(c,"Legend")
end
function muxu.check_set_Urban(c)			 --灵都
	return muxu.check_set(c,"Urban")
end
function muxu.check_set_Butterfly(c)		 --蝶舞
	return muxu.check_set(c,"Butterfly")
end
function muxu.check_set_Lines(c)			 --灵纹
	return muxu.check_set(c,"Lines")
end
function muxu.check_set_Hinbackc(c)		  --莱姆狐
	return muxu.check_set(c,"Hinbackc")
end
