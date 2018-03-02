--IDOL金曲 恋爱捉迷藏
function c14804854.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,14804854+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c14804854.condition)
	e1:SetTarget(c14804854.target)
	e1:SetOperation(c14804854.activate)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetTarget(c14804854.imtg)
	e2:SetValue(c14804854.efilter)
	c:RegisterEffect(e2)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetCode(EFFECT_REMAIN_FIELD)
	c:RegisterEffect(e5)
end
function c14804854.cfilter(c)
	return c:IsSetCard(0x4848)
end
function c14804854.condition(e,tp,eg,ep,ev,re,r,rp)
	return  Duel.IsExistingMatchingCard(c14804854.cfilter,tp,LOCATION_ONFIELD,0,1,nil)
end
function c14804854.thfilter(c,e,tp)
	return c:IsSetCard(0x4848) and c:IsAbleToHand()
end
function c14804854.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c14804854.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	if chk==0 then return true end
	e:GetHandler():SetTurnCounter(0)
	--destroy
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCondition(c14804854.descon)
	e1:SetOperation(c14804854.desop)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END+RESET_OPPO_TURN,3)
	e:GetHandler():RegisterEffect(e1)
	e:GetHandler():RegisterFlagEffect(14804854,RESET_PHASE+PHASE_END+RESET_OPPO_TURN,0,1)
	c14804854[e:GetHandler()]=e1
end
function c14804854.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c14804854.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c14804854.descon(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c14804854.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=c:GetTurnCounter()
   ct=ct+1
   c:SetTurnCounter(ct)
	if ct==1 then
		Duel.SendtoGrave(c,REASON_RULE)
		c:ResetFlagEffect(14804854)
	end
end

function c14804854.imtg(e,c)
	return c:IsSetCard(0x4848)
end
function c14804854.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x4848) and te:IsActiveType(TYPE_MONSTER) 
end