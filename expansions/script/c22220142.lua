--白沢球之首脑
function c22220142.initial_effect(c)
	--synchro summon
	aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsSynchroType,TYPE_SYNCHRO),aux.NonTuner(Card.IsSynchroType,TYPE_MONSTER),1)
	c:EnableReviveLimit()
	--PENDULUM
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(c22220142.pendcon)
	e1:SetOperation(c22220142.pendop)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)
	--mat check
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_MATERIAL_CHECK)
	e2:SetValue(c22220142.valcheck)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c22220142.regcon)
	e3:SetOperation(c22220142.regop)
	c:RegisterEffect(e3)
	e3:SetLabelObject(e2)
end
function c22220142.pfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,false,false) and c:IsSetCard(0x50f)
end
function c22220142.pendcon(e,c)
	if c==nil then return true end
	local ft=Duel.GetMZoneCount(tp)
	if ft<=0 then return false end
	local tp=e:GetOwnerPlayer()
	local g=Duel.GetMatchingGroup(c22220142.pfilter,tp,LOCATION_HAND,0,nil,e,tp)
	return g:FilterCount(aux.PConditionFilter,nil,e,tp,1,3)>0
end
function c22220142.pendop(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
	local tp=e:GetOwnerPlayer()
	local ft=Duel.GetMZoneCount(tp)
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(22220142,0))
	local g=Duel.GetMatchingGroup(c22220142.pfilter,tp,LOCATION_HAND,0,nil,e,tp):Filter(aux.PConditionFilter,nil,e,tp,1,3):Select(tp,1,ft,nil)
	sg:Merge(g)
	Duel.HintSelection(Group.FromCards(c))
end
function c22220142.valcheck(e,c)
	local g=c:GetMaterial()
	local count=g:Filter(Card.IsSetCard,nil,0x50f):FilterCount(Card.IsType,nil,TYPE_MONSTER)
	e:SetLabel(count)
end
function c22220142.regcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO) and e:GetLabelObject():GetLabel()~=0
end
function c22220142.regop(e,tp,eg,ep,ev,re,r,rp)
	local count=e:GetLabelObject():GetLabel()
	local c=e:GetHandler()
	if count>0 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(22220142,1))
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_BE_BATTLE_TARGET)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		e1:SetOperation(c22220142.op1)
		c:RegisterEffect(e1)
	end
	if count>1 then
		local e2=Effect.CreateEffect(c)
		e2:SetDescription(aux.Stringid(22220142,2))
		e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CLIENT_HINT)
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetRange(LOCATION_MZONE)
		e2:SetValue(1500)
		e2:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e2)
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetRange(LOCATION_MZONE)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(1)
		c:RegisterEffect(e3)
		local e4=e3:Clone()
		e4:SetCode(EFFECT_CANNOT_REMOVE)
		c:RegisterEffect(e4)
	end
	if count>2 then
		--indes
		local e5=Effect.CreateEffect(c)
		e5:SetDescription(aux.Stringid(22220142,3))
		e5:SetType(EFFECT_TYPE_FIELD)
		e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e5:SetCode(EFFECT_INDESTRUCTABLE_COUNT)
		e5:SetRange(LOCATION_MZONE)
		e5:SetTargetRange(LOCATION_ONFIELD,0)
		e5:SetTarget(c22220142.indtg)
		e5:SetValue(c22220142.indct)
		c:RegisterEffect(e5)
	end
end
function c22220142.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	if not bc:IsPosition(POS_DEFENSE) then
		Duel.ChangePosition(bc,POS_FACEUP_DEFENSE)
	end
end
function c22220142.indtg(e,c)
	return c:IsFaceup() and c:IsSetCard(0x50f)
end
function c22220142.indct(e,re,r,rp)
	if bit.band(r,REASON_BATTLE+REASON_EFFECT)~=0 then
		return 1
	else return 0 end
end