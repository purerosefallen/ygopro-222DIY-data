--梦见
	yume=yume or {}
	yume.temp_card_field=yume.temp_card_field or {}
if c71400001 then
function c71400001.initial_effect(c)
	--Activate(nofield)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(71400001,1))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(yume.nonYumeCon)
	e1:SetTarget(c71400001.target1)
	e1:SetCost(c71400001.cost)
	e1:SetOperation(c71400001.activate1)
	e1:SetCountLimit(1,71400001+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--Activate(field)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400001,2))
	e2:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCondition(yume.YumeCon)
	e2:SetTarget(c71400001.target2)
	e2:SetCost(c71400001.cost)
	e2:SetOperation(c71400001.activate2)
	e2:SetCountLimit(1,71400001+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e2)
end
function c71400001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,500) end
	Duel.PayLPCost(tp,500)
end
function c71400001.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(71400001,0))
	local tc=Duel.SelectMatchingCard(tp,c71400001.filter1,tp,LOCATION_DECK,0,1,1,nil,tp):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end
function c71400001.activate2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c71400001.filter2,tp,LOCATION_DECK,0,1,1,nil,tp)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
function c71400001.filter1(c,tp)
	return c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true) and c:IsSetCard(0xb714)
end
function c71400001.filter2(c,tp)
	return c:IsSetCard(0x714) and c:IsAbleToHand() and not c:IsCode(71400001)
end
function c71400001.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400001.filter1,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c71400001.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400001.filter2,tp,LOCATION_DECK,0,1,nil,tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
end
--global part
table=require("table")
function yume.AddYumeSummonLimit(c,ssm)
--1=special summon monster, 0=non special summon monster
	ssm=ssm or 0
	local el1=Effect.CreateEffect(c)
	el1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	el1:SetType(EFFECT_TYPE_SINGLE)
	el1:SetCode(EFFECT_SPSUMMON_CONDITION)
	el1:SetCondition(yume.YumeCheck)
	c:RegisterEffect(el1)
	if ssm==0 then
		local el2=el1:Clone()
		el2:SetCode(EFFECT_CANNOT_MSET)
		c:RegisterEffect(el2)
		local el3=el1:Clone()
		el3:SetCode(EFFECT_CANNOT_SUMMON)
		c:RegisterEffect(el3)
	end
end
function yume.GetValueType(v)
	local t=type(v)
	if t=="userdata" then
	local mt=getmetatable(v)
	if mt==Group then return "Group"
	elseif mt==Effect then return "Effect"
	else return "Card" end
	else return t end
end
--[[
Yume SpSummon Check
v in effect = spsummon condition(return true = cannot summon)
v in card = material filter gen(return true = can summon)
--]]
function yume.YumeCheck(v)
	local t=yume.GetValueType(v)
	local function f(c) return c:IsFaceup() and c:IsSetCard(0x3714) end
	if t=="Effect" then
		return not Duel.IsExistingMatchingCard(f,v:GetHandlerPlayer(),LOCATION_FZONE,0,1,nil)
	elseif t=="Card" then
		return function(c) return Duel.IsExistingMatchingCard(f,v:GetControler(),LOCATION_FZONE,0,1,nil) end
	end
end
--Yume Condition
function yume.YumeCon(e,tp,eg,ep,ev,re,r,rp)
	p=e:GetHandlerPlayer()
	tc=Duel.GetFieldCard(p,LOCATION_SZONE,5)
	return tc and tc:IsFaceup() and tc:IsSetCard(0x3714)
end
function yume.nonYumeCon(e,tp,eg,ep,ev,re,r,rp)
	p=e:GetHandlerPlayer()
	tc=Duel.GetFieldCard(p,LOCATION_SZONE,5)
	return tc==nil or tc:IsFacedown() or not tc:IsSetCard(0x3714)
end
--i=sl description, j=fa description, k=pls select a field spell
--ft=field type, 0-Delusion Yume 1-Vision Yume
function yume.AddYumeFieldGlobal(c,id,i,j,msg,ft)
	ft=ft or 0
	if not id then return end
	yume.temp_card_field[c]=yume.temp_card_field[c] or {}
	yume.temp_card_field[c].id=id
	--self limitation
	if i then
		local esl=Effect.CreateEffect(c)
		esl:SetDescription(aux.Stringid(id,i))
		esl:SetType(EFFECT_TYPE_QUICK_F)
		esl:SetCode(EVENT_CHAINING)
		esl:SetRange(LOCATION_FZONE)
		esl:SetCondition(yume.YumeFieldLimitCon)
		esl:SetOperation(yume.YumeFieldLimitOp)
		c:RegisterEffect(esl)
	end
	--field activation
	if j and msg then
		yume.temp_card_field[c].msg=msg
		yume.temp_card_field[c].ft=ft
		local efa=Effect.CreateEffect(c)
		efa:SetDescription(aux.Stringid(id,j))
		efa:SetCategory(EFFECT_TYPE_ACTIVATE)
		efa:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		efa:SetCode(EVENT_LEAVE_FIELD)
		efa:SetRange(LOCATION_FZONE)
		efa:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
		efa:SetCondition(yume.FieldActivationCon)
		efa:SetOperation(yume.FieldActivationOp)
		c:RegisterEffect(efa)
	end
end
--Against Yume
function yume.YumeFieldLimitCon(e,tp,eg,ep,ev,re,r,rp)
	local ec=re:GetHandler()
	return re:IsActiveType(TYPE_MONSTER) and rp==tp and not ec:IsSetCard(0x714)
end
function yume.YumeFieldLimitOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x714))
	e1:SetTargetRange(1,0)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetCode(EFFECT_CANNOT_SUMMON)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x714))
	e2:SetTargetRange(1,0)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_MSET)
	e3:SetReset(RESET_PHASE+PHASE_END)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x714))
	e3:SetTargetRange(1,0)
	Duel.RegisterEffect(e3,tp)
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EFFECT_CANNOT_ACTIVATE)
	e4:SetReset(RESET_PHASE+PHASE_END)
	e4:SetValue(yume.YumeFieldActivationLimit)
	e4:SetTargetRange(1,0)
	Duel.RegisterEffect(e4,tp)
end
function yume.YumeFieldActivationLimit(e,re,tp)
	local c=re:GetHandler()
	return c:IsSetCard(0x714) and not c:IsImmuneToEffect(e)
end
--Field Activation
function yume.FieldActivationFilter(c,tp,num,ft)
	local flag=c:IsType(TYPE_FIELD) and c:GetActivateEffect():IsActivatable(tp,true) and not c:IsCode(num)
	if ft==0 then return flag and c:IsSetCard(0xb714)
	elseif ft==1 then return flag and c:IsSetCard(0x7714)
	end
end
function yume.FieldActivationCon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_EFFECT) and not c:IsLocation(LOCATION_DECK)
		and c:IsPreviousPosition(POS_FACEUP)
end
function yume.FieldActivationOp(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=yume.temp_card_field[c].id
	Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(num,yume.temp_card_field[c].msg))
	local tc=Duel.SelectMatchingCard(tp,yume.FieldActivationFilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,tp,num,yume.temp_card_field[c].ft):GetFirst()
	if tc then
		local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
		if fc then
			Duel.SendtoGrave(fc,REASON_RULE)
			Duel.BreakEffect()
		end
		Duel.MoveToField(tc,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
		local te=tc:GetActivateEffect()
		local tep=tc:GetControler()
		local cost=te:GetCost()
		if cost then cost(te,tep,eg,ep,ev,re,r,rp,1) end
		Duel.RaiseEvent(tc,4179255,te,0,tp,tp,Duel.GetCurrentChain())
	end
end