--白沢球提琴手
function c22220010.initial_effect(c)
	--SpecialSummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_RELEASE+CATEGORY_REMOVE+CATEGORY_DESTROY+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetTarget(c22220010.target)
	e1:SetOperation(c22220010.operation)
	c:RegisterEffect(e1)
	--Recover
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22220010,0))
	e2:SetCategory(CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTarget(c22220010.tg)
	e2:SetOperation(c22220010.op)
	c:RegisterEffect(e2)
	--returnhand
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetOperation(c22220010.rhop)
	c:RegisterEffect(e3)
end
function c22220010.cfilter3(c,code1,code2)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50f) and (not c:IsPublic()) and (not c:IsCode(22220010) and (not c:IsCode(code1)) and (not c:IsCode(code2)))
end
function c22220010.cfilter2(c,code1,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50f) and Duel.IsExistingMatchingCard(c22220010.cfilter3,tp,LOCATION_HAND,0,1,nil,code1,c:GetCode()) and (not c:IsPublic()) and (not c:IsCode(22220010) and (not c:IsCode(code1)))
end
function c22220010.cfilter(c,tp)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x50f) and Duel.IsExistingMatchingCard(c22220010.cfilter2,tp,LOCATION_HAND,0,1,nil,c:GetCode(),tp) and (not c:IsPublic()) and (not c:IsCode(22220010))
end
function c22220010.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c22220010.cfilter,tp,LOCATION_HAND,0,1,nil,tp) and Duel.GetMZoneCount(tp)>0 and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,LOCATION_HAND)
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,0,2,0,LOCATION_HAND+LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,0,2,1-tp,LOCATION_ONFIELD)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,0,2,1-tp,LOCATION_ONFIELD)
end
function c22220010.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsExistingMatchingCard(c22220010.cfilter,tp,LOCATION_HAND,0,1,nil,tp) then return end
	local tc1=Duel.SelectMatchingCard(tp,c22220010.cfilter,tp,LOCATION_HAND,0,1,1,nil,tp):GetFirst()
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsCode,nil,tc1:GetCode()):Filter(c22220010.cfilter,nil,tp)
	local tc2=Duel.SelectMatchingCard(tp,c22220010.cfilter2,tp,LOCATION_HAND,0,1,1,nil,tc1:GetCode(),tp):GetFirst()
	local g2=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsCode,nil,tc2:GetCode()):Filter(c22220010.cfilter2,nil,tc1:GetCode(),tp)
	local tc3=Duel.SelectMatchingCard(tp,c22220010.cfilter3,tp,LOCATION_HAND,0,1,1,nil,tc1:GetCode(),tc2:GetCode()):GetFirst()
	local g3=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsCode,nil,tc3:GetCode()):Filter(c22220010.cfilter3,nil,tc1:GetCode(),tc2:GetCode())
	local g=Group.CreateGroup()
	g:Merge(g1)
	g:Merge(g2)
	g:Merge(g3)
	Duel.ConfirmCards(1-tp,g)
	local ct=g:GetCount()
	if ct>2 and c:IsRelateToEffect(e) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetMZoneCount(tp)>0 then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
	if ct>3 and g:FilterCount(Card.IsReleasableByEffect,nil)>0 and Duel.IsExistingMatchingCard(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) then
		local rg1=g:Filter(Card.IsReleasableByEffect,nil):Select(tp,1,1,nil)
		local rg2=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil):Select(tp,1,1,nil)
		rg1:Merge(rg2)
		Duel.Release(rg1,REASON_EFFECT)
	end
	if ct>5 and Duel.IsExistingMatchingCard(nil,tp,0,LOCATION_ONFIELD,2,nil) then
		local tg=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_ONFIELD,2,2,nil)
		Duel.Destroy(tg,REASON_EFFECT,LOCATION_REMOVED)
	end
end
function c22220010.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(Card.IsType,nil,TYPE_MONSTER):Filter(Card.IsSetCard,nil,0x50f)
	local ct=g:GetSum(Card.GetAttack)
	Duel.SetTargetPlayer(1-tp)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,1-tp,ct)
end
function c22220010.op(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local g=Duel.GetFieldGroup(tp,LOCATION_GRAVE,0):Filter(Card.IsType,nil,TYPE_MONSTER):Filter(Card.IsSetCard,nil,0x50f)
	local ct=g:GetSum(Card.GetAttack)
	Duel.Recover(p,ct,REASON_EFFECT)
end
function c22220010.rhop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.SendtoHand(c,nil,REASON_EFFECT)
end