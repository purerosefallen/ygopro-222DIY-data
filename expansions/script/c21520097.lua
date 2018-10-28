--竹林仙子
function c21520097.initial_effect(c)
	--synchro summon
	c:EnableReviveLimit()
	aux.AddSynchroMixProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),nil,nil,aux.Tuner(nil),1,99)
	--mzone
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(21520097,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c21520097.discon)
	e1:SetTarget(c21520097.distg)
	e1:SetOperation(c21520097.disop)
	c:RegisterEffect(e1)
	--szone
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520097,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCost(c21520097.dscost)
	e2:SetOperation(c21520097.dsop)
	c:RegisterEffect(e2)
	--immune
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c21520097.efilter)
	c:RegisterEffect(e3)
end
function c21520097.efilter(e,te)
	return te:IsActiveType(TYPE_SPELL+TYPE_TRAP) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
function c21520097.discon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SYNCHRO
end
function c21520097.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(1-tp)>0 and Duel.GetMZoneCount(tp)>0 end
end
function c21520097.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(1-tp)<=0 or Duel.GetMZoneCount(tp)<=0 then return end
	if c:GetMaterial():GetCount()<=0 then return end
	local ct=math.min(c:GetMaterial():GetCount(),Duel.GetMZoneCount(tp),Duel.GetMZoneCount(1-tp))
	Duel.Hint(HINT_NUMBER,tp,ct)
	Duel.Hint(HINT_NUMBER,1-tp,ct)
	local dis1=Duel.SelectDisableField(tp,ct,LOCATION_MZONE,0,0)
	local dis2=Duel.SelectDisableField(tp,ct,0,LOCATION_MZONE,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c21520097.disableop)
	e1:SetLabel(dis1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetLabel(dis2)
	c:RegisterEffect(e2)
end
function c21520097.disableop(e,tp)
	return e:GetLabel()
end
function c21520097.dscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_SZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemoveAsCost,tp,LOCATION_SZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c21520097.dsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetMZoneCount(1-tp)<=0 and Duel.GetMZoneCount(tp)<=0 then return end
	local dis1=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,0)
	local dis2=Duel.SelectDisableField(tp,1,0,LOCATION_SZONE,0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_DISABLE_FIELD)
	e1:SetOperation(c21520097.disableop)
	e1:SetLabel(dis1)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetLabel(dis2)
	c:RegisterEffect(e2)
end
