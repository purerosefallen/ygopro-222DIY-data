--德哈琳·救恩圣约
function c75646714.initial_effect(c)
	c:EnableReviveLimit()
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c75646714.spcon)
	e1:SetOperation(c75646714.spop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCountLimit(1,75646714)
	e2:SetOperation(c75646714.op)
	c:RegisterEffect(e2)
	--
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(75646714,1))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_DEFCHANGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_RECOVER)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c75646714.defcon)
	e3:SetTarget(c75646714.deftg)
	e3:SetOperation(c75646714.defop)
	c:RegisterEffect(e3)
	--damage reduce
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CHANGE_DAMAGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetTargetRange(1,0)
	e4:SetValue(c75646714.damval2)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_NO_EFFECT_DAMAGE)
	e5:SetCondition(c75646714.damcon)
	c:RegisterEffect(e5)   
	if not c75646714.global_check then
		c75646714.global_check=true
		c75646714[0]=0
		c75646714[1]=0
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DAMAGE)
		ge1:SetOperation(c75646714.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge2:SetOperation(c75646714.clear)
		Duel.RegisterEffect(ge2,0)
	end
end
c75646714.card_code_list={75646700,75646715}
function c75646714.filter(c)
	return c:IsCode(75646700,75646715) and c:IsAbleToGraveAsCost()
end
function c75646714.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c75646714.filter,tp,LOCATION_HAND,0,1,nil)
end
function c75646714.spop(e,tp,eg,ep,ev,re,r,rp,c)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c75646714.filter,tp,LOCATION_HAND,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c75646714.checkop(e,tp,eg,ep,ev,re,r,rp)
	if ep==tp and bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		c75646714[ep]=c75646714[ep]+1
	end
end
function c75646714.clear(e,tp,eg,ep,ev,re,r,rp)
	c75646714[0]=0
	c75646714[1]=0
end
function c75646714.op(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetCountLimit(1)
	e1:SetOperation(c75646714.remop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function c75646714.remop(e,tp,eg,ep,ev,re,r,rp)
	local ct=c75646714[tp]
	Duel.Recover(tp,ct*1000,REASON_EFFECT)
end
function c75646714.defcon(e,tp,eg,ep,ev,re,r,rp)
	return ep==tp
end
function c75646714.deftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(500)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,500)
end
function c75646714.defop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_DEFENSE)
	e1:SetValue(500)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	e:GetHandler():RegisterEffect(e1)
end
function c75646714.damval2(e,re,val,r,rp,rc)
	local c=e:GetHandler()
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 and c:GetFlagEffect(75646714)==0 then
		c:RegisterFlagEffect(75646714,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
		return 0
	end
	return val
end
function c75646714.damcon(e)
	return e:GetHandler():GetFlagEffect(75646714)==0
end