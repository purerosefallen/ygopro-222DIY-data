--恶噬侵染
function c65020096.initial_effect(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,65020096)
	e1:SetTarget(c65020096.tg)
	e1:SetOperation(c65020096.op)
	c:RegisterEffect(e1)
end
function c65020096.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsFaceup() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.SelectTarget(tp,Card.IsFaceup,tp,0,LOCATION_ONFIELD,1,1,nil)
end
function c65020096.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		tc:RegisterFlagEffect(65020096,RESET_EVENT+RESETS_STANDARD,0,1)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_LEAVE_FIELD)
		e1:SetLabelObject(tc)
		e1:SetCondition(c65020096.thcon)
		e1:SetOperation(c65020096.thop)
		Duel.RegisterEffect(e1,tp)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e2:SetCode(EVENT_PHASE+PHASE_END)
		e2:SetCountLimit(1)
		e2:SetLabelObject(tc)
		e2:SetCondition(c65020096.descon)
		e2:SetOperation(c65020096.desop)
		Duel.RegisterEffect(e2,tp)
	end
end
function c65020096.descon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffect(65020096)~=0 then
		return true
	else
		e:Reset()
		return false
	end
end
function c65020096.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoGrave(tc,REASON_EFFECT)
end
function c65020096.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return (tc:IsLocation(LOCATION_EXTRA) and tc:IsFaceup()) or tc:IsLocation(LOCATION_GRAVE)
end
function c65020096.thfil(c)
	return c:IsSetCard(0xada3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c65020096.spfil(c,e,tp)
	return c:IsSetCard(0xada3) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65020096.thop(e,tp,eg,ep,ev,re,r,rp)
	local b1=Duel.IsExistingMatchingCard(c65020096.thfil,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65020096.spfil,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	local m=2
	if b1 and b2 then
		m=Duel.SelectOption(tp,aux.Stringid(65020096,0),aux.Stringid(65020096,1))
	elseif b1 then
		m=0
	elseif b2 then
		m=1
	end
	if m==0 then
		 local g1=Duel.SelectMatchingCard(tp,c65020080.thfil,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(g1,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
	elseif m==1 then
		local g2=Duel.SelectMatchingCard(tp,c65020084.thfil,tp,LOCATION_DECK,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g2,0,tp,tp,false,false,POS_FACEUP)
	end
	e:Reset()
end