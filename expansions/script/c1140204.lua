--谵妄『陷入疯狂』
local m=1140204
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
--
function c1140204.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1140204.cost1)
	e1:SetOperation(c1140204.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c1140204.con2)
	e2:SetCost(c1140204.cost2)
	e2:SetTarget(c1140204.tg2)
	e2:SetOperation(c1140204.op2)
	c:RegisterEffect(e2)
--
end
--
function c1140204.cfilter1(c)
	return muxu.check_set_Medicine(c) and c:IsType(TYPE_MONSTER)
end
function c1140204.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.CheckReleaseGroup(tp,c1140204.cfilter1,1,nil)
	end
	local sg=Duel.SelectReleaseGroup(tp,c1140204.cfilter1,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
--
function c1140204.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetType(EFFECT_TYPE_FIELD)
	e1_2:SetCode(EFFECT_UPDATE_ATTACK)
	e1_2:SetTargetRange(0,LOCATION_MZONE)
	e1_2:SetValue(600)
	e1_2:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1_2,tp)
	local e1_3=Effect.CreateEffect(c)
	e1_3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1_3:SetCode(EVENT_CHAINING)
	e1_3:SetOperation(c1140204.op1_3)
	e1_3:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1_3,tp)
end
--
function c1140204.op1_3(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if ep==tp then return end
	if rc:GetControler()==tp then return end
	if not rc:IsRelateToEffect(re) then return end
	if not rc:IsLocation(LOCATION_MZONE) then return end
	Duel.Destroy(rc,REASON_EFFECT,LOCATION_REMOVED)
end
--
function c1140204.con2(e,tp,eg,ep,ev,re,r,rp)
	if e==re then return false end
	return re:IsHasProperty(EFFECT_FLAG_CARD_TARGET)
end
--
function c1140204.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToRemoveAsCost() end
	Duel.Remove(c,POS_FACEUP,REASON_COST)
end
--
function c1140204.tfilter2_1(c,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c)
end
function c1140204.tfilter2_2(c,e,re,rp,tf,ceg,cep,cev,cre,cr,crp)
	return tf(re,rp,ceg,cep,cev,cre,cr,crp,0,c) 
		and c:IsCanBeEffectTarget(e)
end
function c1140204.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local ct=ev
	local label=Duel.GetFlagEffectLabel(0,1140204)
	if label then
		if ev==bit.rshift(label,16) then ct=bit.band(label,0xffff) end
	end
	local ce,cp=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT,CHAININFO_TRIGGERING_PLAYER)
	local tf=ce:GetTarget()
	local ceg,cep,cev,cre,cr,crp=Duel.GetChainEvent(ct)
--
	local sg=Group.CreateGroup()
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if tg and tg:GetCount()>0 then
		sg=tg:Filter(Card.IsOnField,nil)
		if sg:GetCount()>0 then tg:Sub(sg) end
	end
--
	if chk==0 then return sg:GetCount()>0 and Duel.IsExistingTarget(c1140204.tfilter2_1,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,sg:GetCount(),nil,ce,cp,tf,ceg,cep,cev,cre,cr,crp) end
--
	local cg=Duel.GetMatchingGroup(c1140204.tfilter2_2,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,e,ce,cp,tf,ceg,cep,cev,cre,cr,crp)
	local ag=cg:RandomSelect(tp,sg:GetCount())
	local val=ct+bit.lshift(ev+1,16)
	if label then
		Duel.SetFlagEffectLabel(0,1140204,val)
	else
		Duel.RegisterFlagEffect(0,1140204,RESET_CHAIN,0,1,val)
	end
	local num=ag:GetCount()
	tg:Merge(ag)
	e:SetLabel(num)
	e:SetLabelObject(tg)
	Duel.SetTargetParam(ag)
	Duel.SetTargetCard(ag)
end
--
function c1140204.op2(e,tp,eg,ep,ev,re,r,rp)
	local num=e:GetLabel()
	local tg=e:GetLabelObject()
	if not tg then return end
	if tg:GetCount()<1 then return end
	if tg:FilterCount(Card.IsRelateToEffect,nil,e)~=num then return end
	Duel.ChangeTargetCard(ev,tg)
end
--
