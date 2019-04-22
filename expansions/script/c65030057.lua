--行于终景间的死亡
function c65030057.initial_effect(c)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCondition(c65030057.con)
	e1:SetTarget(c65030057.tg)
	e1:SetOperation(c65030057.op)
	c:RegisterEffect(e1)
	 --spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetCountLimit(1,65030057)
	e2:SetOperation(c65030057.regop)
	c:RegisterEffect(e2)
end
function c65030057.cfil(c)
	return c:IsFaceup() and c:IsCode(65030052)
end
function c65030057.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetMatchingGroupCount(c65030057.cfil,tp,LOCATION_FZONE,0,nil)==0
end
function c65030057.tgfil(c)
	return c:IsFaceup() and c:IsSetCard(0x6da2) and c:IsAbleToRemove() and not c:IsType(TYPE_TUNER)
end
function c65030057.tffil(c)
	return c:IsCode(65030052) and not c:IsForbidden()
end
function c65030057.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c65030057.tgfil(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c65030057.tgfil,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c65030057.tffil,tp,LOCATION_DECK,0,1,nil) and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	local g=Duel.SelectTarget(tp,c65030057.tgfil,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c65030057.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)~=0 then
		  local g=Duel.SelectMatchingCard(tp,c65030057.tffil,tp,LOCATION_DECK,0,1,1,nil)
			local gc=g:GetFirst()
		if gc and Duel.MoveToField(gc,tp,tp,LOCATION_SZONE,POS_FACEUP,true) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and e:GetHandler():IsRelateToEffect(e) then
			Duel.BreakEffect()
			Duel.SpecialSummon(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP)
		end
	end
end


function c65030057.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetCondition(c65030057.thcon)
	e1:SetOperation(c65030057.thop)
	e1:SetReset(RESET_PHASE+PHASE_DRAW)
	Duel.RegisterEffect(e1,tp)
end
function c65030057.thfilter(c,e,tp)
	return c:IsSetCard(0x6da2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65030057.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c65030057.thfilter,tp,LOCATION_REMOVED,0,1,nil,e,tp) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
end
function c65030057.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,65030057)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c65030057.thfilter,tp,LOCATION_REMOVED,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end