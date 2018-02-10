--岁暮的黑伞-冬至
function c61221.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,1,1,nil,nil,13)
	c:EnableReviveLimit()
	--check overlay group when destroy
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EFFECT_DESTROY_REPLACE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTarget(c61221.reptg)
	e0:SetValue(c61221.repval)
	c:RegisterEffect(e0)
	--swap ad
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetCondition(c61221.adcon)
	e1:SetCode(EFFECT_SWAP_BASE_AD)
	c:RegisterEffect(e1)
	--draw
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(61221,0))
	e2:SetCategory(CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c61221.drcon)
	e2:SetTarget(c61221.drtarg)
	e2:SetOperation(c61221.drop)
	c:RegisterEffect(e2)
	--disable and destroy
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EVENT_CHAIN_SOLVING)
	e4:SetCondition(c61221.tgcon)
	e4:SetOperation(c61221.disop)
	c:RegisterEffect(e4)
	--decrease atk/def
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetCode(EFFECT_UPDATE_ATTACK)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTargetRange(0,LOCATION_MZONE)
	e5:SetCondition(c61221.atkcon)
	e5:SetValue(c61221.atkval)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e6)
	--to wife
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(61221,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EVENT_DESTROY)
	e3:SetLabelObject(e0)
	e3:SetTarget(c61221.thtg)
	e3:SetOperation(c61221.thop)
	c:RegisterEffect(e3)
end
function c61221.adcon(e)
	return e:GetHandler():GetOverlayGroup():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>=1
end
function c61221.drcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ) and e:GetHandler():GetOverlayGroup():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>=2
end
function c61221.drtarg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c61221.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c61221.tgcon(e)
	local eo=e:GetHandler():GetOverlayGroup()
	local p1=eo:IsExists(Card.IsCode,1,nil,60105) or (Duel.GetCurrentPhase()==PHASE_MAIN1 or Duel.GetCurrentPhase()==PHASE_MAIN2)
	return eo:FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>=3
		and p1 and Duel.GetTurnPlayer()==e:GetHandlerPlayer()
end
function c61221.disop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp then return end
	local rc=re:GetHandler()
	if Duel.NegateEffect(ev) and rc:IsRelateToEffect(re) then
		Duel.Destroy(rc,REASON_EFFECT)
	end
end
function c61221.atkcon(e)
	return e:GetHandler():GetOverlayGroup():FilterCount(Card.IsAttribute,nil,ATTRIBUTE_WATER)>=4
end
function c61221.atkval(e,c)
	local dc=Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)
	local wc=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	local dif=0
	if dc~=wc then
		dif=(dc>wc) and (dc-wc) or (wc-dc)
	end
	return dif*-1200
end
function c61221.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local e0 = e:GetLabelObject()
	local g = e0:GetLabelObject()
	if chk==0 then return g and g:GetCount()>=5 end
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
end
function c61221.thop(e,tp,eg,ep,ev,re,r,rp)
	local e0 = e:GetLabelObject()
	local g = e0:GetLabelObject()
	local tg=g:Filter(Card.IsRelateToEffect,nil,e)
	if tg:GetCount()>0 and Duel.SendtoHand(tg,nil,REASON_EFFECT)>0 then
		Duel.ConfirmCards(1-tp,tg)
	end
end
function c61221.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local perg = e:GetLabelObject()
	if perg then 
		perg:DeleteGroup() 
	end
	local nowg = e:GetHandler():GetOverlayGroup():Filter(Card.IsAttribute,nil,ATTRIBUTE_WATER)
	nowg:KeepAlive()
	e:SetLabelObject(nowg)
	return false 
end
function c61221.repval(e,c)
	return false
end
