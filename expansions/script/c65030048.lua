--雾落世 紫喉
function c65030048.initial_effect(c)
	c:EnableReviveLimit()
	--splimit
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e1:SetCondition(c65030048.spcon)
	e1:SetOperation(c65030048.spop)
	c:RegisterEffect(e1)
	--change damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CHANGE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetCondition(c65030048.damcon1)
	e2:SetValue(0)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetTargetRange(0,1)
	e4:SetCondition(c65030048.damcon2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	c:RegisterEffect(e5)
	--todeck!
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetTarget(c65030048.tg)
	e6:SetOperation(c65030048.op)
	c:RegisterEffect(e6)
	--effects
	local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(65030048,1))
	e7:SetCategory(CATEGORY_TODECK)
	e7:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e7:SetType(EFFECT_TYPE_IGNITION)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e7:SetCost(c65030048.effcost)
	e7:SetTarget(c65030048.tdtg)
	e7:SetOperation(c65030048.tdop)
	c:RegisterEffect(e7)
	--wudi
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE)
	e11:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e11:SetRange(LOCATION_MZONE)
	e11:SetCode(EFFECT_UNRELEASABLE_SUM)
	e11:SetValue(1)
	c:RegisterEffect(e11)
	local e12=e11:Clone()
	e12:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	c:RegisterEffect(e12)
	local e17=Effect.CreateEffect(c)
	e17:SetType(EFFECT_TYPE_SINGLE)
	e17:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e17:SetValue(1)
	c:RegisterEffect(e17)
	--unaffectable
	local e18=Effect.CreateEffect(c)
	e18:SetType(EFFECT_TYPE_SINGLE)
	e18:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e18:SetRange(LOCATION_MZONE)
	e18:SetCode(EFFECT_IMMUNE_EFFECT)
	e18:SetValue(c65030048.efilter)
	c:RegisterEffect(e18)
end
function c65030048.effcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function c65030048.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,g:GetCount(),0,0)
end
function c65030048.tffilter(c,tp)
	return c:IsCode(65030049) and not c:IsForbidden() and c:CheckUniqueOnField(tp)
end
function c65030048.op(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD+LOCATION_GRAVE,0,e:GetHandler())
	if Duel.SendtoDeck(g,nil,2,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(c65030048.tffilter,tp,LOCATION_DECK,0,1,nil,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOFIELD)
		local tc=Duel.SelectMatchingCard(tp,c65030048.tffilter,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
		if tc then
			Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		end 
	end
end
function c65030048.tdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tp=Duel.GetTurnPlayer()
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,0,0)
	Duel.SetChainLimit(aux.FALSE)
	e:GetHandler():RegisterFlagEffect(0,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(65030042,2))
end
function c65030048.tdop(e,tp,eg,ep,ev,re,r,rp)
	local tp=Duel.GetTurnPlayer()
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD+LOCATION_GRAVE,1,2,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
	end
end

function c65030048.efilter(e,te)
	return not te:GetOwner():IsSetCard(0x5da2)
end
function c65030048.spcfil(c)
	return c:IsSetCard(0x5da2) and c:IsAbleToGraveAsCost()
end

function c65030048.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-2
		and Duel.IsExistingMatchingCard(c65030048.spcfil,tp,LOCATION_MZONE,0,2,nil) 
end
function c65030048.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.SelectMatchingCard(tp,c65030048.spcfil,tp,LOCATION_MZONE,0,2,2,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c65030048.damcon1(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(tp)<Duel.GetLP(1-tp)
end
function c65030048.damcon2(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(1-tp)<Duel.GetLP(tp)
end