--浅绿色的Eagle Rabbit
function c11200083.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1,11200083)
	e2:SetTarget(c11200083.target)
	e2:SetOperation(c11200083.activate)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetCondition(c11200083.con)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	
end
function c11200083.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,e:GetHandler()) end
end
function c11200083.rfilter(c)
	return c:IsSetCard(0x131) and c:IsAbleToRemove()
end
function c11200083.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,2,c)
	if g:GetCount()>0 then
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		if g:IsExists(Card.IsSetCard,1,nil,0x131) and Duel.SelectYesNo(tp,aux.Stringid(11200083,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
			local g1=Duel.SelectMatchingCard(tp,c11200083.rfilter,tp,LOCATION_GRAVE+LOCATION_DECK,0,1,1,nil)
			Duel.Remove(g1,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c11200083.filter(c)
	return c:IsSetCard(0x131) and c:IsFaceup()
end
function c11200083.con(e)
	local ph=Duel.GetCurrentPhase()
	local tp=e:GetHandler():GetControler()
	return Duel.IsExistingMatchingCard(c11200083.filter,tp,LOCATION_REMOVED,0,1,nil) and ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE
end
