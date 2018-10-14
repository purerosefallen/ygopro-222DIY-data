--咒缚灵殿
function c10109009.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,10109009+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c10109009.target)
	e1:SetOperation(c10109009.activate)
	c:RegisterEffect(e1)
	--atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5332))
	e2:SetValue(c10109009.value)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10109009,0))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetHintTiming(0,TIMING_END_PHASE)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1) 
	e4:SetCost(c10109009.thcost)
	e4:SetTarget(c10109009.thtg)
	e4:SetOperation(c10109009.thop)
	c:RegisterEffect(e4)
end
function c10109009.cfilter2(c)
	return not c:IsForbidden() and c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5332)
end
function c10109009.thcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c10109009.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
	local tc=Duel.SelectMatchingCard(tp,c10109009.cfilter2,tp,LOCATION_HAND+LOCATION_MZONE,0,1,1,nil):GetFirst()
	Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetCode(EFFECT_CHANGE_TYPE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+0x1fc0000)
	e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	tc:RegisterEffect(e1)
	Duel.RaiseEvent(tc,EVENT_CUSTOM+10109001,e,0,tp,0,0)
end
function c10109009.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c10109009.thop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
	   Duel.SendtoHand(e:GetHandler(),nil,REASON_EFFECT)
	end
end
function c10109009.atkfilter(c)
	return c:IsFaceup() and bit.band(c:GetType(),0x20002)==0x20002
end
function c10109009.value(e,c)
	return Duel.GetMatchingGroupCount(c10109009.atkfilter,0,LOCATION_SZONE,LOCATION_SZONE,nil)*200
end
function c10109009.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:SetLabel(Duel.AnnounceNumber(tp,1,2,2,4,5,6,7,8))
end
function c10109009.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) then
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_FIELD)
	   e1:SetCode(EFFECT_CHANGE_LEVEL_FINAL)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   e1:SetRange(LOCATION_FZONE)
	   e1:SetTargetRange(LOCATION_HAND+LOCATION_MZONE,0)
	   e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x5332))
	   e1:SetValue(e:GetLabel())
	   c:RegisterEffect(e1)
	end
end