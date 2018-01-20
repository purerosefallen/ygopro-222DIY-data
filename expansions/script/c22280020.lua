--未临的结晶
--------The way of builtin name Is Adapted From c14141006.lua By 卡 莲  From YGOPro 222DIY,really thx--------
local m=22280020
local cm=_G["c"..m]
if cm then
cm.named_with_Spar=true
function c22280020.initial_effect(c)
	c:EnableReviveLimit()
end
end
if not Arcol then
Arcol={}
Arcol.loaded_metatable_list={}
function Arcol.load_metatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=Arcol.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			Arcol.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function Arcol.check_set(c,setcode,v,f,...) 
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
		local mt=Arcol.load_metatable(code)
		if mt and mt["named_with_"..setcode] and (not v or mt["named_with_"..setcode]==v) then return true end
	end
	return false
end
function Arcol.check_set_Spar(c)
	return Arcol.check_set(c,"Spar")
end
end