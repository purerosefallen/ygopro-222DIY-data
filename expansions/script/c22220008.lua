--白沢球键盘手
function c22220008.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c22220008.target)
	e1:SetOperation(c22220008.operation)
	c:RegisterEffect(e1)
	--ATK&DEF
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22220008,0))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetTarget(c22220008.tg)
	e2:SetOperation(c22220008.op)
	c:RegisterEffect(e2)
	--returnhand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c22220008.rhop)
	c:RegisterEffect(e3)
end
function c22220008.cfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50f) and (not c:IsPublic()) and (not c:IsCode(22220008))
end
function c22220008.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22220008.cfilter,tp,LOCATION_HAND,0,1,nil) and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,0,1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,0,1,tp,LOCATION_DECK)
end
function c22220008.thfilter(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToHand()
end
function c22220008.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c22220008.cfilter,tp,LOCATION_HAND,0,1,nil) then return end
	local tc=Duel.SelectMatchingCard(tp,c22220008.cfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsCode,nil,tc:GetCode()):Filter(c22220008.cfilter,nil)
	Duel.ConfirmCards(1-tp,g)
	local ct=g:GetCount()
	if ct>0 and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if ct>1 and g:FilterCount(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false)>0 and Duel.GetMZoneCount(tp)>0 then
		local sg=g:Filter(Card.IsCanBeSpecialSummoned,nil,e,0,tp,false,false):Select(tp,1,1,nil)
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
	if ct>2 and Duel.IsExistingMatchingCard(c22220008.thfilter,tp,LOCATION_DECK,0,1,nil) then
		local tg=Duel.SelectMatchingCard(tp,c22220008.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c22220008.filter(c)
	return (c:GetLevel()>0 or c:GetRank()>0) and c:IsFaceup()
end
function c22220008.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22220008.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c22220008.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c22220008.filter,tp,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	local c=e:GetHandler()
	while tc do
		if tc:GetLevel()>0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(-(tc:GetLevel()*100))
			tc:RegisterEffect(e1)
			local e2=e1:Clone()
			e2:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e2)
			tc=g:GetNext()
		elseif tc:GetRank()>0 then
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_UPDATE_ATTACK)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			e3:SetValue(-(tc:GetRank()*100))
			tc:RegisterEffect(e3)
			local e4=e3:Clone()
			e4:SetCode(EFFECT_UPDATE_DEFENSE)
			tc:RegisterEffect(e4)
			tc=g:GetNext()
		end
	end
end
function c22220008.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end