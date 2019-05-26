--人格面具-阿娜特
if not pcall(function() require("expansions/script/c15873611") end) then require("script/c15873611") end
local m=15873628
local cm=_G["c"..m]
function cm.initial_effect(c)
	rsphh.SetCode(c,true)
	c:EnableReviveLimit()
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(rsphh.mset),1)
	local e1=rsphh.ImmueFun(c,ATTRIBUTE_WATER)
	local e2=rsphh.EndPhaseFun(c,15873616)  
	local e3=rsef.SV_UPDATE(c,"atk",cm.val)
	--cannot select battle target
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(0,LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SELECT_BATTLE_TARGET)
	e4:SetValue(cm.atlimit)
	c:RegisterEffect(e4)
end
function cm.atlimit(e,c)
	return c~=e:GetHandler() and c:IsFaceup() and (rsphh.set(c) or rsphh.set2(c))
end
function cm.val(e,c)
	return Duel.GetMatchingGroupCount(rscf.FilterFaceUp(Card.IsAttribute,ATTRIBUTE_WATER),e:GetHandlerPlayer(),0,LOCATION_MZONE,nil)*1000
end
