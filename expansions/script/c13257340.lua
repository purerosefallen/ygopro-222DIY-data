--里超时空战斗机-Ikaruga
function c13257340.initial_effect(c)
	c:EnableCounterPermit(0x351)
	c:SetCounterLimit(0x351,10)
	c:EnableReviveLimit()
	--cannot special summon
	local e8=Effect.CreateEffect(c)
	e8:SetType(EFFECT_TYPE_SINGLE)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e8:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e8)
	--special summon
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_FIELD)
	e9:SetCode(EFFECT_SPSUMMON_PROC)
	e9:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e9:SetRange(LOCATION_HAND)
	e9:SetCondition(c13257340.spcon)
	e9:SetOperation(c13257340.spop)
	c:RegisterEffect(e9)
	--add counter
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EVENT_CHAINING)
	e0:SetRange(LOCATION_MZONE)
	e0:SetOperation(aux.chainreg)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e1:SetCode(EVENT_CHAIN_SOLVED)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c13257340.accon)
	e1:SetOperation(c13257340.acop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_IMMUNE_EFFECT)
	e2:SetValue(c13257340.efilter)
	c:RegisterEffect(e2)
	--Power Capsule
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(13257340,0))
	e3:SetCategory(CATEGORY_ATKCHANGE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,0x1e0)
	e3:SetTarget(c13257340.pctg)
	e3:SetOperation(c13257340.pcop)
	c:RegisterEffect(e3)
	--bomb
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(13257340,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1)
	e4:SetCost(c13257340.bombcost)
	e4:SetTarget(c13257340.bombtg)
	e4:SetOperation(c13257340.bombop)
	c:RegisterEffect(e4)
	local e11=Effect.CreateEffect(c)
	e11:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e11:SetCode(EVENT_SPSUMMON_SUCCESS)
	e11:SetOperation(c13257340.bgmop)
	c:RegisterEffect(e11)
	eflist={"power_capsule",e3}
	c13257340[c]=eflist
	
end
function c13257340.spfilter(c,ft,tp)
	return c:IsSetCard(0x351)
		and c:IsControler(tp) and c:IsAbleToGraveAsCost() and (ft>0 or c:GetSequence()<5)
end
function c13257340.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	return ft>-1 and Duel.IsExistingMatchingCard(c13257340.spfilter,tp,LOCATION_MZONE,0,1,nil,ft,tp)
end
function c13257340.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c13257340.spfilter,tp,LOCATION_MZONE,0,1,1,nil,ft,tp)
	Duel.SendtoGrave(g,REASON_COST)
end
function c13257340.efilter(e,te)
	local c=e:GetHandler()
	return ((c:IsAttribute(ATTRIBUTE_LIGHT) and te:IsActiveType(TYPE_MONSTER)) or (c:IsAttribute(ATTRIBUTE_DARK) and te:IsActiveType(TYPE_SPELL+TYPE_TRAP))) and e:GetHandlerPlayer()~=te:GetOwnerPlayer()
end
function c13257340.accon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and c:GetFlagEffect(1)>0 and ((c:IsAttribute(ATTRIBUTE_LIGHT) and re:IsActiveType(TYPE_MONSTER)) or (c:IsAttribute(ATTRIBUTE_DARK) and re:IsActiveType(TYPE_SPELL+TYPE_TRAP)))
end
function c13257340.acop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,13257340)
	if e:GetHandler():GetFlagEffect(1)>0 then
		e:GetHandler():AddCounter(0x351,1)
	end
end
function c13257340.pctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetTurnPlayer()==tp end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATTRIBUTE)
	local att=Duel.AnnounceAttribute(tp,1,0x30)
		local e5=Effect.CreateEffect(e:GetHandler())
		e5:SetType(EFFECT_TYPE_SINGLE)
		e5:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e5:SetValue(att)
		e5:SetReset(RESET_EVENT+0x1fe0000)
		e:GetHandler():RegisterEffect(e5)
end
function c13257340.pcop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		local e6=Effect.CreateEffect(e:GetHandler())
		e6:SetType(EFFECT_TYPE_SINGLE)
		e6:SetCode(EFFECT_UPDATE_ATTACK)
		e6:SetValue(-300)
		e6:SetReset(RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e6)
		local e7=e6:Clone()
		e7:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e7)
	end
end
function c13257340.bombcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():GetCounter(0x351)>0 end
	local ct=e:GetHandler():GetCounter(0x351)
	e:SetLabel(ct)
	e:GetHandler():RemoveCounter(tp,0x351,ct,REASON_COST)
end
function c13257340.bombtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
end
function c13257340.bombop(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetLabel()
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,ct,nil)
	Duel.Destroy(g,REASON_EFFECT)
end
function c13257340.bgmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(11,0,aux.Stringid(13257340,7))
end
