--武者 三世勢州千子右衛門尉村正
function c62501010.initial_effect(c)
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsSetCard,0x624),7,2,c62501010.ovfilter,aux.Stringid(62501010,0),3,c62501010.xyzop)
	c:EnableReviveLimit()
--
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e0:SetValue(1)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_ADD_CODE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(62501000)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c62501010.atkval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(62501010,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_MZONE)
  --  e3:SetCost(c62501010.rmcost)
	e3:SetTarget(c62501010.rmtg)
	e3:SetOperation(c62501010.rmop)
	c:RegisterEffect(e3)

	local e4=Effect.CreateEffect(c)
 --   e4:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetCountLimit(1)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c62501010.discon)
	e4:SetCost(c62501010.discost)
   -- e4:SetTarget(c10443957.distg)
	e4:SetOperation(c62501010.disop)
	c:RegisterEffect(e4)
	
end
function c62501010.ovfilter(c)
	return c:IsFaceup() and c:IsCode(62501000) and c:GetEquipCount()>0
end
function c62501010.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,62501010)==0 end
	Duel.RegisterFlagEffect(tp,62501010,RESET_PHASE+PHASE_END,0,1)
end
function c62501010.atkval(e,c)
	return c:GetOverlayCount()*200
end
function c62501010.rmcost(e,tp,eg,ep,ev,re,r,rp,chk)
	--if chk==0 then return e:GetHandler():GetAttackAnnouncedCount()==0 end
end
function c62501010.tgfilter(c)
	return  c:IsAbleToRemove()
end
function c62501010.tgdfilter(c)
	return  c:IsDestructable()
end
function c62501010.mfilter(c)
	return  c:IsType(TYPE_MONSTER)
end
function c62501010.rmtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c62501010.tgfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c62501010.tgfilter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,c62501010.tgfilter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
  --  local dr= Duel.IsExistingTarget(tp,c62501010.tgdfilter,tp,LOCATION_MZONE,0,1,1,nil)
  --  Duel.SetOperationInfo(0,CATEGORY_DESTROY,dr,1,0,0)
end
function c62501010.rmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if  tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	local g=Duel.SelectTarget(tp,c62501010.tgdfilter,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0) 
		Duel.Destroy(g,REASON_EFFECT)
if Duel.SelectEffectYesNo(tp,e:GetHandler(),aux.Stringid(62501010,2)) then
		local g2=Duel.SelectTarget(tp,c62501010.mfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		if g2:GetCount()>0 then
		Duel.Overlay(c,g2)
	end
end
	end
end
function c62501010.discon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and Duel.IsChainNegatable(ev) and ep~=tp
end
function c62501010.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c62501010.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
end
function c62501010.effilter(e,re)
	return e:GetOwnerPlayer()~=re:GetOwnerPlayer()
end
function c62501010.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e4=Effect.CreateEffect(c)
		e4:SetType(EFFECT_TYPE_SINGLE)
		e4:SetCode(EFFECT_IMMUNE_EFFECT)
		e4:SetValue(c62501010.effilter)
		e4:SetOwnerPlayer(tp)
		e4:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e4)
end
