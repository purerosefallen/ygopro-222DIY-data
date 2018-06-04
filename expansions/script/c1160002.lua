--镜中奇遇·爱丽丝
function c1160002.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(1160002,0))
	e1:SetCategory(CATEGORY_SEARCH)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetTarget(c1160002.tg1)
	e1:SetOperation(c1160002.op1)
	c:RegisterEffect(e1) 
--
	if not c1160002.gchk then
		c1160002.gchk=true
		c1160002[0]=5
		c1160002[1]=5
		local e2=Effect.GlobalEffect()
		e2:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		e2:SetCode(EVENT_SPSUMMON_SUCCESS)
		e2:SetOperation(c1160002.op2)
		Duel.RegisterEffect(e2,0)
		local e3=Effect.GlobalEffect()
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		e3:SetCountLimit(1)
		e3:SetOperation(c1160002.clear3)
		Duel.RegisterEffect(e3,0)
	end
--
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(1160002,0))
	e4:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCountLimit(1,1160002) 
	e4:SetCondition(c1160002.con4)
	e4:SetTarget(c1160002.tg1)
	e4:SetOperation(c1160002.op1)
	c:RegisterEffect(e4) 
--
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(1160002,1))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,1160003)
	e5:SetCost(c1160002.cost5)
	e5:SetTarget(c1160002.tg5)
	e5:SetOperation(c1160002.op5)
	c:RegisterEffect(e5)
--
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_EQUIP)
	e6:SetRange(LOCATION_SZONE)
	e6:SetOperation(c1160002.op6)
	c:RegisterEffect(e6)
--
	Duel.AddCustomActivityCounter(1160002,ACTIVITY_SPSUMMON,c1160002.counterfilter) 
--
end
--
function c1160002.op2(e,tp,eg,ep,ev,re,r,rp)
	if c1160002[rp]<=1 then
		Duel.RegisterFlagEffect(rp,1160003,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(rp,1160002,RESET_PHASE+PHASE_END,0,2)
	else
		c1160002[rp]=c1160002[rp]-1
	end
end
function c1160002.clear3(e,tp,eg,ep,ev,re,r,rp)
	c1160002[0]=5
	c1160002[1]=5
end
--
function c1160002.counterfilter(c)
	return c:GetLevel()==1 or c:IsLocation(LOCATION_EXTRA) 
end
--
function c1160002.tfilter1(c)
	return c:GetLevel()==1 and c:IsAbleToHand() 
end
--
function c1160002.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetCustomActivityCount(1161002,tp,ACTIVITY_SPSUMMON)==0 and Duel.IsExistingMatchingCard(c1160002.tfilter1,tp,LOCATION_DECK,0,1,nil) end
	local e1_1=Effect.CreateEffect(e:GetHandler())
	e1_1:SetType(EFFECT_TYPE_FIELD)
	e1_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1_1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1_1:SetReset(RESET_PHASE+PHASE_END)
	e1_1:SetTargetRange(1,0)
	e1_1:SetTarget(c1160002.tg1_1)
	Duel.RegisterEffect(e1_1,tp)
	Duel.SetOperationInfo(0,CATEGORY_SEARCH,nil,1,tp,LOCATION_DECK)
end
function c1160002.tg1_1(e,c)
	return not (c:GetLevel()==1 or c:IsLocation(LOCATION_EXTRA))
end
--
function c1160002.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c1160002.tfilter1,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
--
function c1160002.con4(e)
	return Duel.GetFlagEffect(1-e:GetHandler():GetControler(),1160002)~=Duel.GetFlagEffect(1-e:GetHandler():GetControler(),1160002)
end
--
function c1160002.cfilter5(c)
	return c:IsAbleToRemoveAsCost()
end
function c1160002.cost5(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c1160002.cfilter5,tp,LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c1160002.cfilter5,tp,LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
--
function c1160002.tfilter5(c,e,tp)
	return c:GetLevel()==1 and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetAttack()>399 and c:IsType(TYPE_MONSTER) and c:IsRace(RACE_WARRIOR)
end
function c1160002.tg5(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.IsExistingMatchingCard(c1160002.tfilter5,tp,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
--
function c1160002.op5(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c1160002.tfilter5,tp,LOCATION_DECK,0,1,1,nil,e,tp)
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP) and Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and tc:IsFaceup() then
			Duel.Equip(tp,c,tc,true)
			local e5_1=Effect.CreateEffect(c)
			e5_1:SetType(EFFECT_TYPE_SINGLE)
			e5_1:SetCode(EFFECT_CHANGE_TYPE)
			e5_1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e5_1:SetValue(TYPE_EQUIP)
			e5_1:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e5_1)
			local e5_2=Effect.CreateEffect(c)
			e5_2:SetType(EFFECT_TYPE_SINGLE)
			e5_2:SetCode(EFFECT_EQUIP_LIMIT)
			e5_2:SetReset(RESET_EVENT+0x1fe0000)
			e5_2:SetLabelObject(tc)
			e5_2:SetValue(c1160002.limit5_2)
			c:RegisterEffect(e5_2)
			local e5_3=Effect.CreateEffect(c)
			e5_3:SetType(EFFECT_TYPE_SINGLE)
			e5_3:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
			e5_3:SetValue(LOCATION_HAND)
			e5_3:SetReset(RESET_EVENT+0x1fe0000)
			c:RegisterEffect(e5_3)
		end
	end
end
function c1160002.limit5_2(e,c)
	return c==e:GetLabelObject()
end
--
function c1160002.op6(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if eg:GetFirst()~=e:GetHandler() then return end
	local tc=c:GetEquipTarget()
	if tc then
		local e6_1=Effect.CreateEffect(c)
		e6_1:SetDescription(aux.Stringid(1160002,2))
		e6_1:SetCategory(CATEGORY_DESTROY)
		e6_1:SetType(EFFECT_TYPE_IGNITION)
		e6_1:SetRange(LOCATION_MZONE)
		e6_1:SetLabelObject(c)
		e6_1:SetCountLimit(1)
		e6_1:SetCondition(c1160002.con6_1)
		e6_1:SetTarget(c1160002.tg6_1)
		e6_1:SetOperation(c1160002.op6_1)
		tc:RegisterEffect(e6_1)
		if e6_1:GetHandler()==nil then return end
	end
end
--
function c1160002.con6_1(e)
	local g=e:GetHandler():GetEquipGroup()
	if g:IsContains(e:GetLabelObject()) then
		return not e:GetLabelObject():IsDisabled()
	else 
		return false
	end
end
function c1160002.tg6_1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(1160002,2)) 
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,0,0,LOCATION_ONFIELD)
end
function c1160002.ofilter6_1(c,tp)
	return c:GetControler()==1-tp and c:IsDestructable()
end
function c1160002.op6_1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetHandler()
	local c=e:GetLabelObject()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and Duel.SelectYesNo(tp,aux.Stringid(1160002,3)) then
		local s=Duel.SelectDisableField(tp,1,LOCATION_SZONE,0,0)
		local nseq=0
		if s==256 then nseq=0
		elseif s==512 then nseq=1
		elseif s==1024 then nseq=2
		elseif s==2048 then nseq=3
		else nseq=4 end
		Duel.MoveSequence(c,nseq)
	end
	local g=c:GetColumnGroup()
	local sg=g:Filter(c1160002.ofilter6_1,nil,tp)
	if sg:GetCount()>0 then
		Duel.Destroy(sg,REASON_EFFECT)
	end
end
--