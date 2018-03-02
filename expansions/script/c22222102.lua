--白沢球的先登
function c22222102.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22222101,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c22222102.condition)
	e1:SetTarget(c22222102.target)
	e1:SetOperation(c22222102.activate)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22222101,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c22222102.con)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c22222102.tg)
	e2:SetOperation(c22222102.op)
	c:RegisterEffect(e2)
end
function c22222102.condition(e,tp,eg,ep,ev,re,r,rp)
	return re:IsHasCategory(CATEGORY_SPECIAL_SUMMON) and re:IsActiveType(TYPE_MONSTER)
end
function c22222102.filter(c,e,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50f) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c22222102.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0 and Duel.IsExistingMatchingCard(c22222102.filter,tp,LOCATION_DECK,0,1,nil,e,tp) end
end
function c22222102.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_END)
	e1:SetOperation(c22222102.retop)
	Duel.RegisterEffect(e1,tp)
end
function c22222102.retop(e,tp,eg,ep,ev,re,r,rp)
	e:Reset()
	local ct=Duel.GetMZoneCount(tp)
	if not (ct>0 and Duel.IsExistingMatchingCard(c22222102.filter,tp,LOCATION_DECK,0,1,nil,e,tp)) then return end
	Duel.Hint(HINT_CARD,0,22222102)
	if ct>2 then ct=2 end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ct=1 end
	local sg=Duel.SelectMatchingCard(tp,c22222102.filter,tp,LOCATION_DECK,0,1,ct,nil,e,tp)
	if sg:GetCount()>0 then
		local sc=sg:GetFirst()
		while sc do
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x47e0000)
			e1:SetValue(LOCATION_HAND)
			sc:RegisterEffect(e1)
			sc=sg:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end
function c22222102.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():GetControler()~=tp
end
function c22222102.tgfilter(c,e,tp)
	return c:IsSetCard(0x50f) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function c22222102.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c22222102.tgfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingTarget(c22222102.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c22222102.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function c22222102.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end