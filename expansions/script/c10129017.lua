--地狱爬行者 巴吉里斯克
function c10129017.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c10129017.ffilter,2,true) 
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c10129017.immcon)
	e1:SetOperation(c10129017.immop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c10129017.valcheck)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetCountLimit(1,10129017)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(c10129017.discon)
	e3:SetCost(c10129017.discost)
	e3:SetTarget(c10129017.distg)
	e3:SetOperation(c10129017.disop)
	c:RegisterEffect(e3)
end
function c10129017.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev)
end
function c10129017.cfilter(c)
	return c:IsRace(RACE_ZOMBIE) and c:IsAbleToRemove()
end
function c10129017.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10129017.cfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c10129017.cfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c10129017.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c10129017.disop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.NegateActivation(ev) and re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function c10129017.ffilter(c,fc,sub,mg,sg)
	return c:IsRace(RACE_ZOMBIE) and (not sg or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode()))
end
function c10129017.immcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION)
end
function c10129017.valcheck(e,c)
	local val=c:GetMaterial():FilterCount(Card.IsFusionType,nil,TYPE_FUSION)
	e:GetLabelObject():SetLabel(val)
end
function c10129017.immop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()>=1 then
	   local e1=Effect.CreateEffect(c)
	   e1:SetDescription(aux.Stringid(10129017,1))
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	   e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	   e1:SetRange(LOCATION_MZONE)
	   e1:SetValue(1)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   c:RegisterEffect(e1)
	end
	if e:GetLabel()>=2 then
	   local e1=Effect.CreateEffect(c)
	   e1:SetDescription(aux.Stringid(10129017,2))
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
	   e1:SetCode(EFFECT_IMMUNE_EFFECT)
	   e1:SetRange(LOCATION_MZONE)
	   e1:SetValue(c10129017.efilter)
	   e1:SetReset(RESET_EVENT+0x1fe0000)
	   c:RegisterEffect(e1)
	end
end
function c10129017.efilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end

