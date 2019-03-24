--STS·高塔
function c107898199.initial_effect(c)
	c:EnableReviveLimit()
	--cannot special summon
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	--destory token
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(107898199,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetCondition(c107898199.cfcon3)
	e2:SetTarget(c107898199.cftg3)
	e2:SetOperation(c107898199.cfop3)
	c:RegisterEffect(e2)
	--indes
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCode(EFFECT_IMMUNE_EFFECT)
	e4:SetValue(c107898199.efilter)
	c:RegisterEffect(e4)
	--remove count
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(107898199,0))
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetCondition(c107898199.cfcon)
	e5:SetOperation(c107898199.cfop)
	c:RegisterEffect(e5)
	--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_HAND_LIMIT)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_GRAVE)
	e6:SetTargetRange(1,0)
	e6:SetValue(c107898199.hdval)
	c:RegisterEffect(e6)
	--disable summon
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD)
	e7:SetRange(LOCATION_GRAVE)
	e7:SetCode(EFFECT_CANNOT_MSET)
	e7:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e7:SetTargetRange(1,0)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetCode(EFFECT_CANNOT_SSET)
	c:RegisterEffect(e8)
	local e9=e7:Clone()
	e9:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e9:SetTarget(c107898199.splimit)
	c:RegisterEffect(e9)
	local e10=e9:Clone()
	e10:SetCode(EFFECT_CANNOT_FLIP_SUMMON)
	c:RegisterEffect(e10)
	local e11=e9:Clone()
	e11:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e11)
	--limit
	local e12=Effect.CreateEffect(c)
	e12:SetType(EFFECT_TYPE_FIELD)
	e12:SetRange(LOCATION_GRAVE)
	e12:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e12:SetCode(EFFECT_CANNOT_ACTIVATE)
	e12:SetTargetRange(1,0)
	e12:SetValue(c107898199.aclimit)
	c:RegisterEffect(e12)
end
function c107898199.hdval(e)
	if Duel.IsPlayerAffectedByEffect(tp,107898208) then
		return 10
	end
	return 0
end
function c107898199.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x575)
end
function c107898199.splimit(e,c)
	return not c:IsSetCard(0x575) and not c:IsCode(107898100)
end
function c107898199.aclimit(e,re,tp)
	return not re:GetHandler():IsCode(107898100) and not re:GetHandler():IsSetCard(0x575)
end
function c107898199.cfcon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.IsCanRemoveCounter(tp,1,0,0x1,1,REASON_EFFECT) and Duel.IsPlayerAffectedByEffect(tp,107898210)==nil
end
function c107898199.tkfilter(c)
	return c:IsFaceup() and c:IsDefensePos() and c:IsSetCard(0x575) and c:IsType(TYPE_TOKEN)
end
function c107898199.cfcon3(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer() and Duel.IsExistingMatchingCard(c107898199.tkfilter,tp,LOCATION_MZONE,0,1,nil) and not Duel.IsPlayerAffectedByEffect(tp,107898503)
end
function c107898199.cftg3(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(c107898199.tkfilter,tp,LOCATION_MZONE,0,nil)
	if chk==0 then return g:GetCount()>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c107898199.cffilter(c)
	return c:IsFaceup() and c:GetCounter(0x1)~=0
end
function c107898199.cfop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c107898199.cffilter,tp,LOCATION_ONFIELD,0,nil)
	local tc=g:GetFirst()
	while tc do 
		local cc=tc:GetCounter(0x1)
		tc:RemoveCounter(tp,0x1,cc,REASON_EFFECT)
		tc=g:GetNext()
	end
end
function c107898199.cffilter1(c)
	return c:IsFaceup() and c:GetCounter(0x1009)~=0
end
function c107898199.cfop3(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c107898199.tkfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Destroy(g,REASON_EFFECT)
end