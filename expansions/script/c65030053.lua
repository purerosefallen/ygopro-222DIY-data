--终景下的交易者
function c65030053.initial_effect(c)
	--summonsuccess
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetTarget(c65030053.tg)
	e1:SetOperation(c65030053.op)
	c:RegisterEffect(e1)
	--spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,65030053)
	e2:SetOperation(c65030053.regop)
	c:RegisterEffect(e2)
end
function c65030053.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c65030053.thcon)
	e1:SetOperation(c65030053.thop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c65030053.thfilter(c)
	return c:IsSetCard(0x6da2) and c:IsAbleToHand()
end
function c65030053.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65030053.thfilter,tp,LOCATION_DECK,0,1,nil)
end
function c65030053.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65030053)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65030053.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,tp,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

function c65030053.tgfil(c)
	return c:IsFaceup() and c:IsCode(65030052)
end
function c65030053.tffil(c)
	return c:IsCode(65030052) and not c:IsForbidden()
end
function c65030053.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,0,e:GetHandler())==0 and Duel.IsExistingMatchingCard(c65030053.tffil,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65030053.tgfil,tp,LOCATION_FZONE,0,1,nil) and Duel.IsPlayerCanSpecialSummon(tp)
	if chk==0 then return true end
	if b2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,LOCATION_HAND)
	end
end
function c65030053.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local b1=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_ONFIELD,0,c)==0 and Duel.IsExistingMatchingCard(c65030053.tffil,tp,LOCATION_DECK,0,1,nil)
	local b2=Duel.IsExistingMatchingCard(c65030053.tgfil,tp,LOCATION_FZONE,0,1,nil)
	if b1 then
		local g=Duel.SelectMatchingCard(tp,c65030053.tffil,tp,LOCATION_DECK,0,1,1,nil)
		local tc=g:GetFirst()
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	elseif b2 and c:IsRelateToEffect(e) then
		if Duel.SendtoHand(c,nil,REASON_EFFECT)~=0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) then
			Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end