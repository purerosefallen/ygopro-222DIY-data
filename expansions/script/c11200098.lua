--人偶
function c11200098.initial_effect(c)
	--rec
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(11200098,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_HAND)
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCountLimit(1,11200098)
	e1:SetCondition(c11200098.reccon)
	e1:SetCost(c11200098.reccost)
	e1:SetTarget(c11200098.rectg)
	e1:SetOperation(c11200098.recop)
	c:RegisterEffect(e1)
	--equip
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200098,1))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCategory(CATEGORY_EQUIP)
	e2:SetRange(LOCATION_HAND+LOCATION_GRAVE)
	e2:SetTarget(c11200098.eqtg)
	e2:SetOperation(c11200098.eqop)
	c:RegisterEffect(e2)
	if not c11200098.wolegequ then
	   c11200098.wolegequ=true
	   c11200098[0]=0
	   c11200098[1]=0
	   local e1=Effect.CreateEffect(c)
	   e1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	   e1:SetCode(EVENT_PAY_LPCOST)
	   e1:SetOperation(c11200098.count)
	   Duel.RegisterEffect(e1,0) 
	   local e2=Effect.CreateEffect(c)
	   e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	   e2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
	   e2:SetOperation(c11200098.resetcount)
	   Duel.RegisterEffect(e2,0)
	end
end
function c11200098.eqfilter(c)
	return c:IsFaceup()
end
function c11200098.eqtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c11200098.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(c11200098.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,c11200098.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	if e:GetHandler():IsLocation(LOCATION_GRAVE) then
		Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,e:GetHandler(),1,0,0)
	end
end
function c11200098.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 or tc:GetControler()~=tp or tc:IsFacedown() or not tc:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		return
	end
	Duel.Equip(tp,c,tc,true)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_EQUIP_LIMIT)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetLabelObject(tc)
	e1:SetValue(c11200098.eqlimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(11200098,3))
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PAY_LPCOST)
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD)
	e2:SetCondition(c11200098.atkcon)
	e2:SetOperation(c11200098.atkop)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e3:SetTarget(c11200098.eftg)
	e3:SetLabelObject(e2)
	c:RegisterEffect(e3)
end
function c11200098.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c11200098.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(1000)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
end
function c11200098.eftg(e,c)
	return e:GetHandler():GetEquipTarget()==c
end
function c11200098.eqlimit(e,c)
	return c==e:GetLabelObject()
end
function c11200098.reccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp 
end
function c11200098.reccost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsPublic() end
end
function c11200098.rectg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return c11200098[tp]>0 end
	local val=math.min(c11200098[tp],2500)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(val)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,val)
end
function c11200098.recop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,math.min(c11200098[p],2500),REASON_EFFECT)
end
function c11200098.resetcount(e,tp,eg,ep,ev,re,r,rp)
	c11200098[0]=0
	c11200098[1]=0
end
function c11200098.count(e,tp,eg,ep,ev,re,r,rp)
	c11200098[ep]=c11200098[ep]+ev
end