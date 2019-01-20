--「02的愤怒」
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m=65010003
local cm=_G["c"..m]
cm.card_code_list={65010001}
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)	
	e1:SetCondition(rscon.excard(rscf.FilterFaceUp(Card.IsCode,65010001)))
	e1:SetTarget(rstg.target(Card.IsAbleToRemove,"rm",0,LOCATION_ONFIELD+LOCATION_GRAVE,1))
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=rscf.GetTargetCard()
	if tc then Duel.Remove(tc,POS_FACEUP,REASON_EFFECT) end
end
