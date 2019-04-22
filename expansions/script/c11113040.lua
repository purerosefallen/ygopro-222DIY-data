--战场女武神 奥黛丽与柯迪莉雅
function c11113040.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,c11113040.matfilter,2)
	c:EnableReviveLimit()
	--cannot link material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetCondition(c11113040.linkcon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	--search or special summon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,11113040)
	e2:SetCondition(c11113040.spcon)
	e2:SetTarget(c11113040.sptg)
	e2:SetOperation(c11113040.spop)
	c:RegisterEffect(e2)
	--cannot negate & battle destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(11113040,1))
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_STANDBY_PHASE)
	e3:SetCountLimit(1,111130400)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c11113040.condition)
	e3:SetTarget(c11113040.target)
	e3:SetOperation(c11113040.operation)
	c:RegisterEffect(e3)
end
function c11113040.matfilter(c)
	return not c:IsLinkType(TYPE_LINK) and c:IsSetCard(0x15c)
end
function c11113040.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c11113040.tgfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_FUSION) and c:IsSetCard(0x15c)
end
function c11113040.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11113040.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c11113040.tgfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local g=Duel.SelectTarget(tp,c11113040.tgfilter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c11113040.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsFaceup() and tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetValue(1)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_FIELD)
		e2:SetCode(EFFECT_CANNOT_DISEFFECT)
		e2:SetValue(c11113040.effectfilter)
		e2:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e2,tp)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_CANNOT_INACTIVATE)
		Duel.RegisterEffect(e3,tp)
		tc:RegisterFlagEffect(11113040,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
	end
end
function c11113040.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:GetFlagEffect(11113040)~=0
end
function c11113040.linkcon(e)
    local c=e:GetHandler()
	return c:IsStatus(STATUS_SPSUMMON_TURN) and c:IsSummonType(SUMMON_TYPE_LINK)
end
function c11113040.spcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c11113040.filter1(c,e,tp)
	return c:IsSetCard(0x15c) and c:IsType(TYPE_TUNER) and not c:IsType(TYPE_PENDULUM) 
	    and (c:IsAbleToHand() or c:IsCanBeSpecialSummoned(e,0,tp,false,false))
end
function c11113040.filter2(c,e,tp)
	return c:IsFaceup() and c:IsSetCard(0x15c) and c:IsType(TYPE_PENDULUM) 
	    and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c11113040.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c11113040.filter1,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c11113040.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(11113040,3))
	local g=Duel.SelectMatchingCard(tp,c11113040.filter1,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local sc=g:GetFirst()
		if sc then
			if ft>0 and sc:IsCanBeSpecialSummoned(e,0,tp,false,false)
			   and (not sc:IsAbleToHand() or Duel.SelectYesNo(tp,aux.Stringid(11113040,4))) then
			    Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)
			else
			    Duel.SendtoHand(sc,nil,REASON_EFFECT)
			    Duel.ConfirmCards(1-tp,sc)
			end	
		end
	end
end