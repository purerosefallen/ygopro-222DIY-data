--白笛 崭新之波多尔多
function c33330018.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,8,2)
	c:EnableReviveLimit()
	--direct
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(33330018,0))
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(c33330018.condition)
	e2:SetCost(c33330018.cost)
	e2:SetOperation(c33330018.operation)
	c:RegisterEffect(e2)
	--actlimit
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetValue(c33330018.aclimit)
	e3:SetCondition(c33330018.actcon)
	c:RegisterEffect(e3) 
	--token
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(33330018,1))
	e5:SetCategory(CATEGORY_TOKEN+CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetCost(c33330018.rcost)
	e5:SetCondition(c33330018.actcon)
	e5:SetTarget(c33330018.tktg)
	e5:SetOperation(c33330018.tkop)
	c:RegisterEffect(e5)   
	--search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33330018,2))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCost(c33330018.recost)
	e1:SetTarget(c33330018.retg)
	e1:SetOperation(c33330018.reop)
	c:RegisterEffect(e1)  
end
function c33330018.recost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsCanRemoveCounter(tp,1,0,0x1019,1,REASON_COST) end
	local ct=Duel.GetCounter(tp,1,0,0x1019)
	Duel.RemoveCounter(tp,1,0,0x1019,ct,REASON_COST)
	e:SetLabel(ct)
end
function c33330018.retg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=e:GetLabel()
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(ct*300)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ct*300)
end
function c33330018.reop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Recover(p,d,REASON_EFFECT)
end
function c33330018.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsAbleToEnterBP() and not e:GetHandler():IsHasEffect(EFFECT_DIRECT_ATTACK)
end
function c33330018.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c33330018.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFaceup() and c:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DIRECT_ATTACK)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		c:RegisterEffect(e1)
	end
end
function c33330018.costfilter(c,ft,tp)
	return (ft>0 or (c:IsControler(tp) and c:GetSequence()<5))
end
function c33330018.rcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if chk==0 then return ft>-1 and Duel.CheckReleaseGroup(tp,c33330018.costfilter,1,nil,ft,tp) end
	local g=Duel.SelectReleaseGroup(tp,c33330018.costfilter,1,1,nil,ft,tp)
	Duel.Release(g,REASON_COST)
end
function c33330018.tktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
	and Duel.IsPlayerCanSpecialSummonMonster(tp,33330035,0,0x4011,2000,2000,8,RACE_ZOMBIE,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end
function c33330018.tkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	if Duel.IsPlayerCanSpecialSummonMonster(tp,33330035,0,0x4011,2000,2000,8,RACE_ZOMBIE,ATTRIBUTE_DARK) then
		local token=Duel.CreateToken(tp,33330035)
		Duel.SpecialSummon(token,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function c33330018.aclimit(e,re,tp)
	return not re:GetHandler():IsImmuneToEffect(e)
end
function c33330018.actcon(e)
	return Duel.GetAttacker()==e:GetHandler()
end

