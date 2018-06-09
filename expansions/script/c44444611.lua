--魂印龙 Darkness
function c44444611.initial_effect(c)
	--spirit
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--disable
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetTarget(c44444611.distg)
	c:RegisterEffect(e1)
   	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--summon
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(44444611,0))
	e12:SetCountLimit(1,44444611)
	e12:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e12:SetCategory(CATEGORY_SUMMON)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_HAND)
    e12:SetCondition(c44444611.spcon)
	e12:SetTarget(c44444611.target)
	e12:SetOperation(c44444611.operation)
	c:RegisterEffect(e12)

end
function c44444611.distg(e,c)
	return c:GetCounter(0x1080)>0 and c:GetCode()~=44444611
end
function c44444611.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 

end
function c44444611.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c44444611.spfilter1(c)
	return c:IsType(TYPE_MONSTER)
end
function c44444611.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(c44444611.spfilter1,tp,LOCATION_MZONE,0,nil)
	if g>2 then g=2 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
	and Duel.CheckReleaseGroup(tp,c44444611.spfilter,2,e:GetHandler())
	and e:GetHandler():IsSummonable(true,e) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c44444611.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
		if c:IsSummonable(true,nil) then
	    Duel.Summon(tp,c,true,nil)
	    local e4=Effect.CreateEffect(c)
        e4:SetType(EFFECT_TYPE_SINGLE)
        e4:SetCode(EFFECT_CANNOT_DIRECT_ATTACK)
        e4:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
        e4:SetReset(RESET_EVENT+0x1fe0000)
        c:RegisterEffect(e4,true)
	end
end