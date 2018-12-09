--灵动君王
function c21520087.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,c21520087.fsfilter,2,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c21520087.sprcon)
	e0:SetOperation(c21520087.sprop)
	c:RegisterEffect(e0)
	--indes
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e1:SetCondition(c21520087.indescon)
	e1:SetValue(1)
	c:RegisterEffect(e1)
	local e1_2=e1:Clone()
	e1_2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	c:RegisterEffect(e1_2)
	--water
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(21520087,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(ATTRIBUTE_WATER)
	e2:SetCode(EVENT_BATTLE_DAMAGE)
	e2:SetCondition(c21520087.con1)
	e2:SetCost(c21520087.cost)
	e2:SetTarget(c21520087.tg1)
	e2:SetOperation(c21520087.op1)
	c:RegisterEffect(e2)
	--fire
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520087,1))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabel(ATTRIBUTE_FIRE)
	e3:SetCountLimit(1)
	e3:SetCondition(c21520087.con2)
	e3:SetCost(c21520087.cost)
	e3:SetTarget(c21520087.tg2)
	e3:SetOperation(c21520087.op2)
	c:RegisterEffect(e3)
	--dark
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(21520087,2))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetLabel(ATTRIBUTE_DARK)
	e4:SetCountLimit(1)
	e4:SetCondition(c21520087.con2)
	e4:SetCost(c21520087.cost)
	e4:SetTarget(c21520087.tg3)
	e4:SetOperation(c21520087.op3)
	c:RegisterEffect(e4)
	--light
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(21520087,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetLabel(ATTRIBUTE_LIGHT)
	e5:SetCountLimit(1)
	e5:SetCondition(c21520087.con2)
	e5:SetCost(c21520087.cost)
	e5:SetTarget(c21520087.tg4)
	e5:SetOperation(c21520087.op4)
	c:RegisterEffect(e5)
end
function c21520087.fsfilter(c)
	return (c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000) and c:IsCanBeFusionMaterial()
end
function c21520087.spfilter(c)
	return (c:GetBaseAttack()>=2400 and c:GetBaseDefense()>=1000) and c:IsCanBeFusionMaterial() and c:IsAbleToDeckOrExtraAsCost()
end
function c21520087.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=false
	if sg:GetCount()<2 then
		res=mg:IsExists(c21520087.fselect,1,sg,tp,mg,sg)
	else
		res=Duel.GetLocationCountFromEx(tp,tp,sg)>0
	end
	sg:RemoveCard(c)
	return res
end
function c21520087.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c21520087.spfilter,tp,LOCATION_MZONE,0,nil)
	local sg=Group.CreateGroup()
	return mg:IsExists(c21520087.fselect,1,nil,tp,mg,sg)
end
function c21520087.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c21520087.spfilter,tp,LOCATION_MZONE,0,nil)
	local sg=Group.CreateGroup()
	while sg:GetCount()<2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local g=mg:FilterSelect(tp,c21520087.fselect,1,1,sg,tp,mg,sg)
		sg:Merge(g)
	end
	local cg=sg:Filter(Card.IsFacedown,nil)
	if cg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,cg)
	end
	Duel.SendtoDeck(sg,nil,2,REASON_COST)
end
function c21520087.indescon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsStatus(STATUS_SPSUMMON_TURN)
end
function c21520087.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,math.floor(Duel.GetLP(tp)/2))
end
function c21520087.effectfilter(c,attr)
	return c:IsFaceup() and c:IsAttribute(attr)
end
function c21520087.con1(e,tp,eg,ep,ev,re,r,rp)
	local attr=e:GetLabel()
	return Duel.IsExistingMatchingCard(c21520087.effectfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,attr) 
		and e:GetHandler():GetAttackedCount()>0 and ep~=tp 
end
function c21520087.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 end
end
function c21520087.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>0 then
		local g=Duel.GetDecktopGroup(tp,1)
		local tc=g:GetFirst()
		Duel.DisableShuffleCheck()
		Duel.ConfirmDecktop(tp,1)
		if tc:IsType(TYPE_MONSTER) then
			Duel.ShuffleDeck(tp)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EXTRA_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(c:GetAttackedCount())
			c:RegisterEffect(e1)
		end
	end
end
function c21520087.con2(e,tp,eg,ep,ev,re,r,rp)
	local attr=e:GetLabel()
	return Duel.IsExistingMatchingCard(c21520087.effectfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil,attr) 
end
function c21520087.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsAbleToRemove() and chkc:IsOnField() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,0,LOCATION_ONFIELD)
end
function c21520087.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)>0 then
			local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_DECK,LOCATION_DECK,nil,tc:GetCode())
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			Duel.ConfirmCards(tp,Duel.GetFieldGroup(1-tp,LOCATION_DECK,0))
			Duel.ConfirmCards(1-tp,Duel.GetFieldGroup(tp,LOCATION_DECK,0))
			Duel.ShuffleDeck(tp)
			Duel.ShuffleDeck(1-tp)
		end
	end
end
function c21520087.tg3(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,LOCATION_MZONE,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,1-tp,LOCATION_MZONE)
end
function c21520087.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,0,LOCATION_MZONE)
	if c:IsRelateToEffect(e) and g:GetCount()>0 then
		if Duel.Destroy(g,REASON_EFFECT)>0 then
			local og=Duel.GetOperatedGroup()
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			e1:SetValue(1000*og:GetCount())
			c:RegisterEffect(e1)
		end
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetOperation(c21520087.rmop)
	Duel.RegisterEffect(e2,p)
end
function c21520087.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,e:GetOwnerPlayer(),LOCATION_HAND+LOCATION_ONFIELD,0,e:GetHandler())
	Duel.Remove(g,POS_FACEDOWN,REASON_EFFECT)
end
function c21520087.sprfilter(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsFaceup()
end
function c21520087.tg4(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return c21520087.sprfilter(chkc,e,tp) and chkc:IsLocation(LOCATION_REMOVED) end
	if chk==0 then return Duel.IsExistingTarget(c21520087.sprfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c21520087.sprfilter,tp,LOCATION_REMOVED,LOCATION_REMOVED,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,LOCATION_REMOVED)
end
function c21520087.op4(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)>0 then
			local val=math.floor(tc:GetAttack()/1000)
			if val>0 then
				Duel.BreakEffect()
				local g=Duel.GetDecktopGroup(1-tp,val)
				Duel.DisableShuffleCheck()
				Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
			end
		end
	end
end
