--令人感伤的红雨
function c1157001.initial_effect(c)
--
	c:EnableReviveLimit()
	aux.AddLinkProcedure(c,c1157001.mfilter,1)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	e1:SetValue(1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1157001,0))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c1157001.con2)
	e2:SetCost(c1157001.cost2)
	e2:SetTarget(c1157001.tg2)
	e2:SetOperation(c1157001.op2)
	c:RegisterEffect(e2)
--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(1157001,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetTarget(c1157001.tg3)
	e3:SetOperation(c1157001.op3)
	c:RegisterEffect(e3)
--
	if not c1157001.global_check then
		c1157001.global_check=true
		local e4=Effect.GlobalEffect()
		e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_DESTROYED)
		e4:SetOperation(c1157001.op4)
		Duel.RegisterEffect(e4,0)
	end
--
end
--
function c1157001.mfilter(c)
	return c:IsLinkRace(RACE_PLANT)
end
--
function c1157001.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,1157001)~=Duel.GetFlagEffect(1-tp,1157002)
end
--
function c1157001.sfilter2(c)
	return c:IsRace(RACE_PLANT) and c:IsReleasable()
end
function c1157001.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1157001.sfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local sg=Duel.SelectMatchingCard(tp,c1157001.sfilter2,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.Release(sg,REASON_EFFECT)
end
--
function c1157001.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local sg=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,sg,sg:GetCount(),0,0)
end
--
function c1157001.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local sc=Duel.GetFirstTarget()
	if not sc:IsRelateToEffect(e) then return end
	if Duel.Destroy(sc,REASON_EFFECT)<1 then return end
	Duel.Damage(1-tp,800,REASON_EFFECT)
end
--
function c1157001.tfilter3(c,e,tp)
	return c:IsCode(1157002) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1157001.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1157001.tfilter3,tp,LOCATION_EXTRA,0,1,nil,e,tp) and Duel.GetLocationCountFromEx(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c1157001.op3(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCountFromEx(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c1157001.tfilter3,tp,LOCATION_EXTRA,0,1,1,nil,e,tp)
	if sg:GetCount()<1 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
end
--
function c1157001.op4(e,tp,eg,ep,ev,re,r,rp)
	if eg:IsExists(Card.IsRace,1,nil,RACE_PLANT) 
		and bit.band(r,REASON_EFFECT)~=0 then
		Duel.RegisterFlagEffect(rp,1157001,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(rp,1157002,RESET_PHASE+PHASE_END,0,2)
	end
end
--
