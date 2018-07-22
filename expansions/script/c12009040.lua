--天鹅绒之音
function c12009040.initial_effect(c)
	--gggg
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12009040,0))
	e1:SetCategory(CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,12009040)
	e1:SetCost(aux.bfgcost)
	e1:SetCondition(c12009040.condition)
	e1:SetTarget(c12009040.target) 
	e1:SetOperation(c12009040.operation)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_BE_MATERIAL)
	e2:SetCondition(c12009040.atkcon)
	e2:SetOperation(c12009040.atkop)
	c:RegisterEffect(e2)	
end
function c12009040.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c12009040.filter(c)
	if c:IsFacedown() or not c:IsType(TYPE_LINK) or not c:IsAbleToExtra() or not c:IsSummonType(SUMMON_TYPE_LINK) then return false end
	local mg=c:GetMaterial()
	return mg:GetCount()>0 and mg:IsExists(Card.IsType,1,nil,TYPE_TUNER)
end
function c12009040.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and c12009040.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c12009040.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,c12009040.filter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA,g,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_GRAVE)
end
function c12009040.mgfilter(c,e,tp,linkc)
	return c:IsControler(tp) and c:IsLocation(LOCATION_GRAVE)
		and bit.band(c:GetReason(),REASON_MATERIAL+REASON_LINK)==REASON_MATERIAL+REASON_LINK and c:GetReasonCard()==linkc 
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c12009040.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) then return end
	local mg=tc:GetMaterial()
	local ct=mg:GetCount()
	local sumtype=tc:IsSummonType(SUMMON_TYPE_LINK)
	if Duel.SendtoDeck(tc,nil,0,REASON_EFFECT)~=0 and sumtype and ct>0 and ct<=Duel.GetLocationCount(tp,LOCATION_MZONE)
		and mg:FilterCount(aux.NecroValleyFilter(c12009040.mgfilter),nil,e,tp,tc)==ct and (mg:GetCount()==1 or not Duel.IsPlayerAffectedByEffect(tp,59822133))
		and Duel.SelectYesNo(tp,aux.Stringid(12009040,1)) then
		Duel.BreakEffect()
		Duel.SpecialSummon(mg,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c12009040.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return r==REASON_SYNCHRO
end
function c12009040.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=c:GetReasonCard()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(rc:GetLevel()*600)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	rc:RegisterEffect(e1,true)
end