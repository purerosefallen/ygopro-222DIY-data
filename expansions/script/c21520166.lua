--形魔-瑟科尔
function c21520166.initial_effect(c)
	--cost
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e00:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e00:SetCode(EVENT_PHASE+PHASE_END)
	e00:SetCountLimit(1)
	e00:SetRange(LOCATION_MZONE)
	e00:SetCondition(c21520166.ccon)
	e00:SetOperation(c21520166.ccost)
	c:RegisterEffect(e00)
	--Attribute Light
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_ADD_ATTRIBUTE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(e1)
	--special summon
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SPSUMMON_PROC)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e3:SetRange(LOCATION_HAND)
	e3:SetCondition(c21520166.spcon)
	c:RegisterEffect(e3)
	--atk & def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetCode(EFFECT_SET_ATTACK)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetValue(c21520166.adval)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e5)
	--add card
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(21520166,3))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_BATTLE_DAMAGE)
	e6:SetCondition(c21520166.thcon)
	e6:SetTarget(c21520166.thtg)
	e6:SetOperation(c21520166.thop)
	c:RegisterEffect(e6)
end
function c21520166.cfilter1(c)
	return c:IsType(TYPE_MONSTER) and c:IsAttribute(ATTRIBUTE_DARK) and not c:IsPublic()
end
function c21520166.ccon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c21520166.ccost(e,tp)
	if tp~=Duel.GetTurnPlayer() then return end
	local c=e:GetHandler()
	Duel.HintSelection(Group.FromCards(c))
	local g1=Duel.GetMatchingGroup(c21520166.cfilter1,tp,LOCATION_HAND,0,nil)
	local opselect=2
	if g1:GetCount()>0 then
		opselect=Duel.SelectOption(tp,aux.Stringid(21520166,0),aux.Stringid(21520166,1),aux.Stringid(21520166,2))
	else 
		opselect=Duel.SelectOption(tp,aux.Stringid(21520166,1),aux.Stringid(21520166,2))
		opselect=opselect+1
	end
	if opselect==0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
		local g=g1:Select(tp,1,1,nil)
		Duel.ConfirmCards(1-tp,g)
		Duel.ShuffleHand(tp)
	elseif opselect==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetCategory(CATEGORY_ATKCHANGE)
		e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetRange(LOCATION_MZONE)
		e1:SetValue(-c:GetAttack())
		e1:SetReset(RESET_PHASE+PHASE_STANDBY,2)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCategory(CATEGORY_DEFCHANGE)
		e2:SetCode(EFFECT_UPDATE_DEFENSE)
		e2:SetValue(-c:GetDefense())
		c:RegisterEffect(e2)
	else
		Duel.Destroy(e:GetHandler(),REASON_RULE)
	end
end
function c21520166.spcon(e,c)
	if c==nil then return true end
	return Duel.GetFieldGroupCount(c:GetControler(),LOCATION_MZONE,0,nil)==0
		and Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)>0
end
function c21520166.adfliter(c,attr)
	return c:IsAttribute(attr) and c:IsFaceup()
end
function c21520166.adval(e,c)
	return (Duel.GetMatchingGroupCount(c21520166.adfliter,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil,ATTRIBUTE_LIGHT)+Duel.GetMatchingGroupCount(c21520166.adfliter,c:GetControler(),LOCATION_GRAVE+LOCATION_MZONE,LOCATION_GRAVE+LOCATION_MZONE,nil,ATTRIBUTE_DARK))*200
end
function c21520166.thcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c21520166.thfilter(c)
	return c:IsSetCard(0x490) and c:IsLevelBelow(4) and c:IsAbleToHand()
end
function c21520166.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c21520166.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c21520166.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c21520166.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		Duel.BreakEffect()
		local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Select(tp,1,1,nil)
		Duel.SendtoDeck(g1,nil,2,REASON_EFFECT)
	end
end
