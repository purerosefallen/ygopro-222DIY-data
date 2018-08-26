--异态魔女·解-99
local m=14000507
local cm=_G["c"..m]
cm.named_with_Spositch=1
xpcall(function() require("expansions/script/c14000501") end,function() require("script/c14000501") end)
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_SPELLCASTER),3,3,cm.lcheck)
	c:EnableReviveLimit()
	--act qp in hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_QP_ACT_IN_NTPHAND)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetCondition(cm.qpcon)
	c:RegisterEffect(e1)
	--cannot be target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	c:RegisterEffect(e2)
end
cm.loaded_metatable_list=cm.loaded_metatable_list or {}
function cm.LoadMetatable(code)
	local m1=_G["c"..code]
	if m1 then return m1 end
	local m2=cm.loaded_metatable_list[code]
	if m2 then return m2 end
	_G["c"..code]={}
	if pcall(function() dofile("expansions/script/c"..code..".lua") end) or pcall(function() dofile("script/c"..code..".lua") end) then
		local mt=_G["c"..code]
		_G["c"..code]=nil
		if mt then
			cm.loaded_metatable_list[code]=mt
			return mt
		end
	else
		_G["c"..code]=nil
	end
end
function cm.check_link_set_SPO(c)
	if c:IsLinkType(TYPE_LINK) then return end
	local codet={c:GetLinkCode()}
	for j,code in pairs(codet) do
		local mt=cm.LoadMetatable(code)
		if mt then
			for str,v in pairs(mt) do   
				if type(str)=="string" and str:find("_Spositch") and v then return true end
			end
		end
	end
	return false
end
function cm.lfilter(c)
	return c:IsLinkType(TYPE_TUNER) and cm.check_link_set_SPO(c)
end
function cm.lcheck(g,lc)
	return g:IsExists(cm.lfilter,1,nil)
end
function cm.qpcon(e)
	return e:GetHandler():GetSequence()>4
end