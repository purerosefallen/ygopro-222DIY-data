--Ⅷ集团军 烈焰之术士
function c16001004.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,16001004)
	e1:SetCondition(c16001004.spcon)
	e1:SetOperation(c16001004.spop)
	c:RegisterEffect(e1)
	--burn
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(16001004,0))
	e2:SetCategory(CATEGORY_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c16001004.dcon)
	e2:SetTarget(c16001004.dtg)
	e2:SetOperation(c16001004.dop)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(16001004,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetCode(EVENT_TO_GRAVE)
	e3:SetCondition(c16001004.descon)
	e3:SetTarget(c16001004.destg)
	e3:SetOperation(c16001004.desop)
	c:RegisterEffect(e3)
end
function c16001004.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c16001004.spop(e,tp,eg,ep,ev,re,r,rp,c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0xfe0000)
	c:RegisterEffect(e1)
end
function c16001004.dcon(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetOverlayCount(tp,1,1)
	return ct>=5
end
function c16001004.dtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetOverlayCount(tp,LOCATION_ONFIELD)+Duel.GetOverlayCount(1-tp,LOCATION_ONFIELD)
	if chk==0 then return ct>=1 end
	Duel.SetTargetPlayer(1-tp)
	Duel.SetTargetParam(ct*300)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*300)
end
function c16001004.dop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetOverlayCount(tp,LOCATION_ONFIELD)+Duel.GetOverlayCount(1-tp,LOCATION_ONFIELD)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	Duel.Damage(p,ct*300,REASON_EFFECT)
end
function c16001004.descon(e,tp,eg,ep,ev,re,r,rp)
	if not re then return end
	local c,rc=e:GetHandler(),re:GetHandler()
	return c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and rc:IsSetCard(0x5c1) and rc:IsType(TYPE_XYZ) and c:IsPreviousLocation(LOCATION_OVERLAY)
end
function c16001004.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c16001004.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end