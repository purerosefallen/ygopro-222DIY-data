--超越空间的恋香 丘依儿
function c12005004.initial_effect(c)
	--draw or Destroy
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetOperation(c12005004.drop)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c12005004.atkcon)
	e2:SetValue(1000)
	c:RegisterEffect(e2)
	if not c12005004.global_check then
		c12005004.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(c12005004.checkop)
		Duel.RegisterEffect(ge1,0)
	end
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12005004,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetRange(LOCATION_HAND)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetCountLimit(1,12005004)
	e1:SetTarget(c12005004.target)
	e1:SetOperation(c12005004.operation)
	c:RegisterEffect(e1)
end
function c12005004.callback(c)
	local tp=c:GetPreviousControler()
	if c:IsSetCard(0xfbb) and c:IsControler(tp) then
		Duel.RegisterFlagEffect(0,12005004,RESET_EVENT+RESET_PHASE+PHASE_END,0,1)
	end
end
function c12005004.checkop(e,tp,eg,ep,ev,re,r,rp)
	eg:ForEach(c12005004.callback)
end
function c12005004.drop(e,tp,eg,ep,ev,re,r,rp)
	if not re:IsHasType(EFFECT_TYPE_ACTIVATE) or not re:IsActiveType(TYPE_COUNTER) then return end
	sel=Duel.SelectOption(tp,aux.Stringid(12005004,3),aux.Stringid(12005004,4))+1
	if sel==1 then
	Duel.Hint(HINT_CARD,0,12005004)
	Duel.BreakEffect()
	Duel.Draw(tp,1,REASON_EFFECT)
	else
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	   Duel.HintSelection(dg)
	   Duel.Destroy(dg,REASON_EFFECT)
	end
end
function c12005004.atkcon(e)
	local tg=Duel.GetFlagEffect(0,12005004)
	return tg>0
end
function c12005004.filter(c)
	return c:IsSetCard(0xfbb) and c:IsFaceup() and c:IsAbleToHand() and not c:IsCode(12005004)
end
function c12005004.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c12005004.filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then return c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c12005004.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c12005004.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
end
function c12005004.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		local tc=Duel.GetFirstTarget()
		if tc:IsRelateToEffect(e) then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end