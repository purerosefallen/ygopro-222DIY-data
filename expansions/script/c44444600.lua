--魂印龙 Fire
function c44444600.initial_effect(c)
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
	e12:SetDescription(aux.Stringid(44444600,1))
	e12:SetCountLimit(1,44444600)
	e12:SetHintTiming(TIMING_BATTLE_PHASE,0x1c0+TIMING_BATTLE_PHASE)
	e12:SetCategory(CATEGORY_SUMMON)
	e12:SetType(EFFECT_TYPE_QUICK_O)
	e12:SetCode(EVENT_FREE_CHAIN)
	e12:SetRange(LOCATION_HAND)
    e12:SetCost(c44444600.spcon)
	e12:SetTarget(c44444600.target)
	e12:SetOperation(c44444600.operation)
	c:RegisterEffect(e12)
	--sset
	local e41=Effect.CreateEffect(c)
	e41:SetDescription(aux.Stringid(44444600,2))
	e41:SetCountLimit(1,99999660)
	e41:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e41:SetCode(EVENT_SUMMON_SUCCESS)
	e41:SetCost(c44444600.scost)
	e41:SetTarget(c44444600.settg)
	e41:SetOperation(c44444600.setop)
	c:RegisterEffect(e41)
	local e51=e41:Clone()
	e51:SetCode(EVENT_FLIP)
	c:RegisterEffect(e51)
end
--速攻召唤
function c44444600.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 
    and Duel.GetMatchingGroupCount(Card.IsType,tp,LOCATION_EXTRA,0,nil,TYPE_MONSTER)<=1
end
function c44444600.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetTurnPlayer()~=tp 
		and e:GetHandler():IsSummonable(true,e) end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,e:GetHandler(),1,0,0)
end
function c44444600.operation(e,tp,eg,ep,ev,re,r,rp)
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
--限制对方怪兽到魔陷区
function c44444600.scost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c44444600.costfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOHAND)
	local g=Duel.SelectMatchingCard(tp,c44444600.costfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SendtoHand(g,nil,2,REASON_COST)
end
function c44444600.costfilter1(c)
	return c:IsAbleToHandAsCost()
end
function c44444600.filter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttackPos()
end
function c44444600.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_SZONE,1-tp)>0 
	and Duel.IsExistingMatchingCard(c44444600.filter,tp,0,LOCATION_MZONE,1,nil,tp) end
end
function c44444600.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(44444600,3))
	local c=e:GetHandler()
	local tc=Duel.SelectMatchingCard(tp,c44444600.filter,tp,0,LOCATION_MZONE,1,1,nil,tp):GetFirst()
	if tc then
		Duel.MoveToField(tc,tp,1-tp,LOCATION_SZONE,POS_FACEUP,true)
		local e1=Effect.CreateEffect(c)
	    e1:SetType(EFFECT_TYPE_SINGLE)
	    e1:SetCode(EFFECT_CHANGE_TYPE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	    e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
		e1:SetReset(RESET_EVENT+0x1fe0000)
	    tc:RegisterEffect(e1)
	end
end
