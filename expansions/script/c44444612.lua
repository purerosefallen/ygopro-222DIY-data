--魂印龙 Chaos
function c44444612.initial_effect(c)
	--spirit
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(444446112,0))
	e1:SetCountLimit(1,444446112)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c44444612.thtg)
	e1:SetOperation(c44444612.thop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
   	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--summon
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(444446112,0))
	e12:SetCountLimit(1,99999672)
	e12:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e12:SetCategory(CATEGORY_SUMMON)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_HAND)
    e12:SetCondition(c44444612.spcon)
	e12:SetTarget(c44444612.target)
	e12:SetOperation(c44444612.operation)
	c:RegisterEffect(e12)
	--spsummon
	local e14=Effect.CreateEffect(c)
	e14:SetDescription(aux.Stringid(444446112,0))
	e14:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e14:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e14:SetProperty(EFFECT_FLAG_DELAY)
	e14:SetCountLimit(1,99999692)
	e14:SetCode(EVENT_LEAVE_FIELD)
	e14:SetCondition(c44444612.scon)
	e14:SetTarget(c44444612.sptg)
	e14:SetOperation(c44444612.spop)
	c:RegisterEffect(e14)
end	
function c44444612.thfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c44444612.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44444612.thfilter,tp,0xc,0xc,1,nil) end
	local g=Duel.GetMatchingGroup(c44444612.thfilter,tp,0xc,0xc,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c44444612.thop(e,tp,eg,ep,ev,re,r,rp,c)
	 local g=Duel.GetMatchingGroup(c44444612.thfilter,tp,0xc,0xc,nil)
	 if g:GetCount()>0 then 
	 Duel.SendtoHand(g,nil,1,REASON_EFFECT)
	 end
end
function c44444612.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 
	and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_MONSTER)<=1
end
function c44444612.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c44444612.spfilter1(c)
	return c:IsType(TYPE_MONSTER)
end
function c44444612.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(c44444612.spfilter1,tp,LOCATION_MZONE,0,nil)
	if g>2 then g=2 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
	and Duel.CheckReleaseGroup(tp,c44444612.spfilter,2,e:GetHandler())
	and e:GetHandler():IsSummonable(true,e) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c44444612.operation(e,tp,eg,ep,ev,re,r,rp)
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
function c44444612.scon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsReason(REASON_BATTLE) 

end
function c44444612.filter11(c,e,tp)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsCanBeSpecialSummoned(e,0,tp,true,false) 
end
function c44444612.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c44444612.filter11,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e,tp) end
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c44444612.spop(e,tp,eg,ep,ev,re,r,rp)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft<=0 then return end
	local c=e:GetHandler()
	if ft>2 then ft=2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c44444612.filter11,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,ft,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
		Duel.SpecialSummonStep(tc,0,tp,tp,true,false,POS_FACEUP)
        local e1=Effect.CreateEffect(e:GetHandler())
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetCode(EFFECT_CHANGE_TYPE)
	    e1:SetValue(TYPE_MONSTER+TYPE_NORMAL)
		e1:SetReset(RESET_EVENT+0x1fe0000)
	    tc:RegisterEffect(e1)
	    local e2=e1:Clone()
	    e2:SetCode(EFFECT_CHANGE_LEVEL)
	    e2:SetValue(4)
	    tc:RegisterEffect(e2)
	    local e4=e1:Clone()
	    e4:SetCode(EFFECT_CHANGE_RACE)
	    e4:SetValue(RACE_DRAGON)
	    tc:RegisterEffect(e4)
	    local e5=e1:Clone()
	    e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
	    e5:SetValue(ATTRIBUTE_DARK)
	    tc:RegisterEffect(e5)
		local e6=e1:Clone()
	    e6:SetCode(EFFECT_SET_BASE_ATTACK)
	    e6:SetValue(1450)
	    tc:RegisterEffect(e6)
		local e7=e1:Clone()
	    e7:SetCode(EFFECT_SET_BASE_DEFENSE)
	    e7:SetValue(1450)
	    tc:RegisterEffect(e7)
		tc=g:GetNext()
		end
		Duel.SpecialSummonComplete()
	end
end