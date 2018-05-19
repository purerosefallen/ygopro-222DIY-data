--飘有甜味的神明
function c1157002.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1157002.mfilter,1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1157002,0))
	e2:SetCategory(CATEGORY_LVCHANGE+CATEGORY_RECOVER)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c1157002.con2)
	e2:SetCost(c1157002.cost2)
	e2:SetTarget(c1157002.tg2)
	e2:SetOperation(c1157002.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1157002,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c1157002.tg3)
	e3:SetOperation(c1157002.op3)
	c:RegisterEffect(e3)
--
end
--
function c1157002.mfilter(c)
	return c:IsLinkRace(RACE_PLANT)
end
--
function c1157002.cfilter2(c)
	return c:IsRace(RACE_PLANT)
end
function c1157002.con2(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp and eg:Filter(c1157002.cfilter2,nil)
end
--
function c1157002.sfilter2(c)
	return c:IsRace(RACE_PLANT) and c:IsReleasable()
end
function c1157002.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1157002.sfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c1157002.sfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Release(sg,REASON_EFFECT)
end
--
function c1157002.tfilter2(c)
	return c:GetLevel()>0 and c:IsFaceup()
end
function c1157002.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingTarget(c1157002.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	local num=Duel.GetMatchingGroupCount(c1157002.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local sg=Duel.SelectTarget(tp,c1157002.tfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,num,nil)
end
--
function c1157002.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e):Filter(Card.IsFaceup,nil)
	if sg:GetCount()<1 then return end
	local sc=sg:GetFirst()
	while sc do
		local e2_1=Effect.CreateEffect(c)
		e2_1:SetType(EFFECT_TYPE_SINGLE)
		e2_1:SetCode(EFFECT_UPDATE_LEVEL)
		e2_1:SetValue(1)
		e2_1:SetReset(RESET_EVENT+0x1fe0000)
		sc:RegisterEffect(e2_1)
		sc=sg:GetNext()
	end
	Duel.Recover(tp,sg:GetCount()*800,REASON_EFFECT)
end
--
function c1157002.tfilter3(c,e,tp)
	return c:IsCode(1157001) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1157002.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1157002.tfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1157002.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c1157002.tfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if sg:GetCount()<1 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
--

