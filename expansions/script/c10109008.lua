--促动剂8
function c10109008.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10109008,0))
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,10109008)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetRange(LOCATION_SZONE)
	e1:SetCost(c10109008.drcost)
	e1:SetTarget(c10109008.drtg)
	e1:SetOperation(c10109008.drop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_HAND+LOCATION_MZONE)
	e2:SetCountLimit(1,10109108)
	e2:SetTarget(c10109008.reptg)
	e2:SetValue(c10109008.repval)
	e2:SetOperation(c10109008.repop)
	c:RegisterEffect(e2)
end
function c10109008.repfilter(c,tp)
	return c:IsFaceup() and c:IsSetCard(0x5332) and c:IsOnField() and c:IsControler(tp) and c:IsReason(REASON_EFFECT+REASON_BATTLE)
end
function c10109008.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not e:GetHandler():IsForbidden() and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and eg:IsExists(c10109008.repfilter,1,nil,tp) end
	return Duel.SelectYesNo(tp,aux.Stringid(10109008,1))
end
function c10109008.repval(e,c)
	return c10109008.repfilter(c,e:GetHandlerPlayer())
end
function c10109008.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,10109008)
	if not c:IsForbidden() and Duel.MoveToField(c,tp,tp,LOCATION_SZONE,POS_FACEUP,true) then
	   local e1=Effect.CreateEffect(c)
	   e1:SetCode(EFFECT_CHANGE_TYPE)
	   e1:SetType(EFFECT_TYPE_SINGLE)
	   e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	   e1:SetReset(RESET_EVENT+0x1fc0000)
	   e1:SetValue(TYPE_SPELL+TYPE_CONTINUOUS)
	   c:RegisterEffect(e1)
	   Duel.RaiseEvent(c,EVENT_CUSTOM+10109001,e,0,tp,0,0)
	end
end
function c10109008.cfilter(c)
	return c:IsSetCard(0x5332) and c:IsReleasable()
end
function c10109008.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c10109008.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local g=Duel.SelectMatchingCard(tp,c10109008.cfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,1,1,e:GetHandler())
	Duel.Release(g,REASON_COST)
end
function c10109008.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and bit.band(e:GetHandler():GetType(),0x20002)==0x20002 end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c10109008.drop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end