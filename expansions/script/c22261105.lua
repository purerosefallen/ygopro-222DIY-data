--月下的针锋相对
function c22261105.initial_effect(c)
	--activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,22261105+EFFECT_COUNT_CODE_OATH)
	e1:SetCondition(c22261105.condition)
	e1:SetOperation(c22261105.activate)
	c:RegisterEffect(e1)
	if not c22261105.global_check then
		c22261105.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c22261105.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c22261105.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
c22261105.Desc_Contain_NanayaShiki=1
function c22261105.IsNanayaShiki(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_NanayaShiki
end
function c22261105.checkop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if a:IsStatus(STATUS_BATTLE_DESTROYED) then
		c22261105[a:GetControler()]=c22261105[a:GetControler()]+1
	end
	if d and d:IsStatus(STATUS_BATTLE_DESTROYED) then
		c22261105[d:GetControler()]=c22261105[d:GetControler()]+1
	end
end
function c22261105.clear(e,tp,eg,ep,ev,re,r,rp)
	c22261105[0]=0
	c22261105[1]=0
end
function c22261105.cfilter(c)
	return c:IsFaceup() and c22261105.IsNanayaShiki(c)
end
function c22261105.condition(e,tp,eg,ep,ev,re,r,rp)
	return (Duel.GetCurrentPhase()~=PHASE_DAMAGE or not Duel.IsDamageCalculated()) and Duel.IsExistingMatchingCard(c22261105.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil)
end
function c22261105.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rg=Duel.GetMatchingGroup(Card.IsFaceup,tp,LOCATION_MZONE,0,nil)
	local rc=rg:GetFirst()
	while rc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(700)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		rc:RegisterEffect(e1)
		rc=rg:GetNext()
	end
	--Draw
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetOperation(c22261105.drop)
	Duel.RegisterEffect(e2,tp)
end
function c22261105.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=c22261105[tp]
	if ct>0 then Duel.Draw(tp,ct,REASON_EFFECT) end
	e:Reset()
end
