--雾落 赤镰
function c65030046.initial_effect(c)
	--SPSUMMON
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e0:SetCountLimit(1,65030046)
	e0:SetCondition(c65030046.spcon)
	e0:SetOperation(c65030046.spop)
	c:RegisterEffect(e0)
	--change damage
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CHANGE_DAMAGE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetCondition(c65030046.damcon1)
	e1:SetValue(0)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetTargetRange(0,1)
	e3:SetCondition(c65030046.damcon2)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e4)
	--SEARCH
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(65030046,1))
	e5:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e5:SetCountLimit(1)
	e5:SetCost(c65030046.effcost)
	e5:SetTarget(c65030046.drtg)
	e5:SetOperation(c65030046.drop)
	c:RegisterEffect(e5)
	--sprule
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(1,0)
	e6:SetTarget(c65030046.splimit)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EFFECT_CANNOT_SUMMON)
	c:RegisterEffect(e7)
end
function c65030046.splimit(e,c)
	return not c:IsSetCard(0x5da2)
end
function c65030046.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.CheckLPCost(tp,500) 
end
function c65030046.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.PayLPCost(tp,500)
end
function c65030046.damcon1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c65030046.damcon2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(1-tp)<Duel.GetLP(tp)
end
function c65030046.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c65030046.drfil(c)
	return c:IsType(TYPE_SPELL) and c:IsSetCard(0x5da2)
end
function c65030046.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local gp=Duel.GetTurnPlayer()
	local hp=e:GetHandlerPlayer()
	if chk==0 then return (Duel.IsExistingMatchingCard(Card.IsType,gp,LOCATION_DECK,0,1,nil,TYPE_SPELL) and gp~=hp) or (gp==hp and Duel.IsExistingMatchingCard(c65030046.drfil,gp,LOCATION_DECK,0,1,nil)) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0)
	Duel.SetChainLimit(aux.FALSE)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65030042,2))
end

function c65030046.drop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local gp=Duel.GetTurnPlayer()
	local hp=e:GetHandlerPlayer()
	if gp~=hp then
		local g=Duel.SelectMatchingCard(gp,Card.IsType,gp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,gp,REASON_EFFECT)
			Duel.ConfirmCards(1-gp,g)
		end
	elseif gp==tp then
		local g=Duel.SelectMatchingCard(gp,c65030046.drfil,gp,LOCATION_DECK,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,gp,REASON_EFFECT)
			Duel.ConfirmCards(1-gp,g)
		end
	end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e1:SetCode(EFFECT_UNRELEASABLE_SUM)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e2)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e7:SetValue(1)
	e7:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e7)
	local e11=Effect.CreateEffect(c)
	e11:SetCode(EFFECT_IMMUNE_EFFECT)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e11:SetRange(LOCATION_MZONE)
	e11:SetValue(c65030046.efilter)
	c:RegisterEffect(e11)
end
function c65030046.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x5da2)
end