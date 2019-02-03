--迷失水界的世界
function c65050017.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTarget(c65050017.hsptg)
	e1:SetOperation(c65050017.hspop)
	c:RegisterEffect(e1)
	--must be material
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetTarget(c65050017.target)
	e2:SetOperation(c65050017.activate)
	c:RegisterEffect(e2)
end
function c65050017.hspfilter(c,e,tp)
	return c:IsSetCard(0xcda3) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c65050017.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c65050017.hspfilter,tp,LOCATION_DECK,0,1,nil,e,tp) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c65050017.hspop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c65050017.hspfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 then Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) end
end
function c65050017.eftg(e,c)
	return c:IsType(TYPE_EFFECT) and c:IsSetCard(0xcda3) 
end
function c65050017.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and chkc:IsSetCard(0xcda3) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsSetCard,tp,0,LOCATION_MZONE,1,nil,0xcda3) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,Card.IsSetCard,tp,0,LOCATION_MZONE,1,1,nil,0xcda3)
end
function c65050017.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	local c=e:GetHandler()
	if tc and tc:IsRelateToEffect(e) then
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_MZONE)
		e3:SetCode(EFFECT_MUST_BE_FMATERIAL)
		e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e3:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		e3:SetTargetRange(1,0)
		tc:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_MUST_BE_SMATERIAL)
		tc:RegisterEffect(e4)
		local e5=e3:Clone()
		e5:SetCode(EFFECT_MUST_BE_LMATERIAL)
		tc:RegisterEffect(e5)
	end
end