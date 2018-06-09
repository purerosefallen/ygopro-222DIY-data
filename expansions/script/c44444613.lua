--魂印龙 Fate
function c44444613.initial_effect(c)
	--spirit
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
   	--cannot special summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e3)
	--summon
	local e12=Effect.CreateEffect(c)
	e12:SetDescription(aux.Stringid(44444613,0))
	e12:SetCountLimit(1,44444613)
	e12:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e12:SetCategory(CATEGORY_SUMMON)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_HAND)
    e12:SetCondition(c44444613.spcon)
	e12:SetTarget(c44444613.target)
	e12:SetOperation(c44444613.operation)
	c:RegisterEffect(e12)
	--destroy
	local e13=Effect.CreateEffect(c)
	e13:SetDescription(aux.Stringid(44444613,1))
	e13:SetCountLimit(1,99999673)
	e13:SetCategory(CATEGORY_DESTROY)
	e13:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e13:SetProperty(EFFECT_FLAG_DELAY)
	e13:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e13:SetCode(EVENT_SUMMON_SUCCESS)
	e13:SetTarget(c44444613.destg)
	e13:SetOperation(c44444613.desop)
	c:RegisterEffect(e13)
	local e23=e13:Clone()
	e23:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e23)

end
function c44444613.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 
	and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_MONSTER)<=1
end
function c44444613.spfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsReleasable()
end
function c44444613.spfilter1(c)
	return c:IsType(TYPE_MONSTER)
end
function c44444613.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroupCount(c44444613.spfilter1,tp,LOCATION_MZONE,0,nil)
	if g>2 then g=2 end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
	and Duel.CheckReleaseGroup(tp,c44444613.spfilter,2,e:GetHandler())
	and e:GetHandler():IsSummonable(true,e) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c44444613.operation(e,tp,eg,ep,ev,re,r,rp)
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
function c44444613.filter(c)
	return c:IsDestructable() and c:IsAbleToHand()
end
function c44444613.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(c44444613.filter,tp,0xc,0xc,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c44444613.filter,tp,0xc,0xc,1,2,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c44444613.desop(e,tp,eg,ep,ev,re,r,rp)
	   local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e) 
	   if g:GetCount()>0 then	
			local opt=Duel.SelectOption(tp,aux.Stringid(44444613,2),aux.Stringid(44444613,3))
			if opt==0 then
				Duel.Destroy(g,REASON_EFFECT)
			else
				 Duel.SendtoHand(g,nil,1,REASON_EFFECT)
			end
	end
end	