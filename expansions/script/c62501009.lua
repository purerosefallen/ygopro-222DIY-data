--劍冑姬 足利茶茶丸
function c62501009.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c62501009.matfilter,1,1)
--material limit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
-- spell tohand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(62501009,1))
	e2:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,62510091)
	e2:SetTarget(c62501009.destg)
	e2:SetOperation(c62501009.desop)
	c:RegisterEffect(e2)
--leave field special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(6250100,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetCountLimit(1,62510092)
	e3:SetCondition(c62501009.spscon)
	e3:SetTarget(c62501009.spstg)
	e3:SetOperation(c62501009.spsop)
	c:RegisterEffect(e3)
--
end
function c62501009.matfilter(c)
	return c:IsCode(62501003) and c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c62501009.thfilter(c)
	return  c:IsSetCard(0x626) and c:IsAbleToHand()
end
function c62501009.desfilter(c)
	return  c:IsType(TYPE_MONSTER) 
end
function c62501009.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and chkc:IsFaceup()  end
	if chk==0 then return Duel.IsExistingTarget(c62501009.desfilter,tp,LOCATION_ONFIELD,0,1,c)
		and Duel.IsExistingMatchingCard(c62501009.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c62501009.desfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function c62501009.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,c62501009.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.BreakEffect()
			Duel.SendtoHand(g,tp,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end
function c62501009.spscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP) and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c62501009.spfilter(c,e,tp)
	return c:IsSetCard(0x624) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c62501009.spstg(e,tp,eg,ep,ev,re,r,rp,chk)
	 if chkc then return chkc:IsLocation(LOCATION_GRAVE+LOCATION_SZONE) and chkc:IsControler(tp) and c62501009.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c62501009.spfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c62501009.spfilter,tp,LOCATION_GRAVE+LOCATION_SZONE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c62501009.spsop(e,tp,eg,ep,ev,re,r,rp)
   local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end