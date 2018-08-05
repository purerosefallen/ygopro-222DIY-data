--毒符『神经之毒』
local m=1140201
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c1110198") end,function() require("script/c1110198") end)
cm.named_with_Poison=true
--
function c1140201.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c1140201.cost1)
	e1:SetOperation(c1140201.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCondition(c1140201.con2)
	e2:SetCost(c1140201.cost2)
	e2:SetTarget(c1140201.tg2)
	e2:SetOperation(c1140201.op2)
	c:RegisterEffect(e2)
--
end
--
function c1140201.cfilter1(c,ft,tp)
	return c:IsRace(RACE_PLANT) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c1140201.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then 
		return Duel.CheckReleaseGroup(tp,c1140201.cfilter1,1,nil)
	end
	local sg=Duel.SelectReleaseGroup(tp,c1140201.cfilter1,1,1,nil)
	Duel.Release(sg,REASON_COST)
end
--
function c1140201.op1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local pt=Duel.GetTurnCount()
	local e1_2=Effect.CreateEffect(c)
	e1_2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_2:SetType(EFFECT_TYPE_FIELD)
	e1_2:SetCode(0x10000000+1140201)
	e1_2:SetTargetRange(0,1)
	e1_2:SetLabel(pt)
	e1_2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1_2,tp)
	local e1_1=Effect.CreateEffect(c)
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetCode(EFFECT_ACTIVATE_COST)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetTargetRange(0,1)
	e1_1:SetLabel(0)
	e1_1:SetLabelObject(e1_2)
	e1_1:SetTarget(c1140201.tg1_1)
	e1_1:SetCost(c1140201.cost1_1)
	e1_1:SetOperation(c1140201.op1_1)
	e1_1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1_1,tp)
end
--
function c1140201.tg1_1(e,te,tp)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_MONSTER)
end
--
function c1140201.cost1_1(e,te_or_c,tp)
	local ct1=Duel.GetFlagEffect(tp,1140201)
	local ct2=Duel.GetFlagEffect(tp,79323590)
	local clp=ct1*100+Duel.GetFlagEffect(tp,1140202)*20+ct2*500
	return Duel.CheckLPCost(tp,clp)
end
--
function c1140201.op1_1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,1140201)
	local e1_2=e:GetLabelObject()
	local pt=e1_2:GetLabel()
	Duel.PayLPCost(tp,e:GetLabel()*20+100)
	if pt~=Duel.GetTurnCount() then
		Duel.RegisterFlagEffect(tp,1140202,RESET_PHASE+PHASE_END,0,1)
	else
		Duel.RegisterFlagEffect(tp,1140202,RESET_PHASE+PHASE_END,0,2)
	end
	e:SetLabel(e:GetLabel()+1)
end
--
function c1140201.con2(e,tp,eg,ep,ev,re,r,rp)
	local loc=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION)
	return loc==LOCATION_MZONE and re:IsActiveType(TYPE_MONSTER)
		and re:GetHandler():IsSummonType(SUMMON_TYPE_SPECIAL)
end
--
function c1140201.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeckAsCost() end
	Duel.SendtoDeck(c,nil,2,REASON_COST)
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(1140201,0))
end
--
function c1140201.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local rc=re:GetHandler()
	if chk==0 then return rc:IsType(TYPE_MONSTER) end
end
--
function c1140201.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if rc:IsFacedown() then return end
	if not rc:IsType(TYPE_MONSTER) then return end
	if not rc:IsRelateToEffect(re) then return end
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_SINGLE)
	e2_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2_1:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	e2_1:SetValue(1)
	e2_1:SetReset(RESET_EVENT+0x1fe0000)
	rc:RegisterEffect(e2_1)
	local e2_2=e2_1:Clone()
	e2_2:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	rc:RegisterEffect(e2_2)
	local e2_3=e2_1:Clone()
	e2_3:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	rc:RegisterEffect(e2_3)
	local e2_4=e2_1:Clone()
	e2_4:SetDescription(aux.Stringid(1140201,0))
	e2_4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
	e2_4:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	rc:RegisterEffect(e2_4)
end
--
