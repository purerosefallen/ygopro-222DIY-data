--幽远与静谧之心
function c1110113.initial_effect(c)
--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c1110113.con1)
	e1:SetOperation(c1110113.op1)
	c:RegisterEffect(e1)
--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(1110113,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetLabel(0)
	e2:SetCost(c1110113.cost2)
	e2:SetTarget(c1110113.tg2)
	e2:SetOperation(c1110113.op2)
	c:RegisterEffect(e2)
--
end
--
function c1110113.exfilter1(c,fc)
	if c==fc then return false end
	return c1110113.allfilter1(c,fc)
end
function c1110113.allfilter1(c,fc)
	return c:IsCanBeFusionMaterial(fc) and c:IsFusionType(TYPE_MONSTER)
		and (c:IsRace(RACE_SPELLCASTER) or c:IsLevel(1))
end
--
function c1110113.CheckFusionFilter1(c,sg,tc)
	local check1=0
	local check2=0
	local sc=sg:GetFirst()
	while sc do
		if sc:IsLevel(1) then check1=1 end
		if sc:IsRace(RACE_SPELLCASTER) then check2=1 end
		sc=sg:GetNext()
	end
	return (check1==0 and tc:IsLevel(1))
		or (check2==0 and tc:IsRace(RACE_SPELLCASTER))
end
function c1110113.CheckRecursive1(c,mg,sg,exg,tp,fc,chkf)
	if exg and exg:IsContains(c) and not sg:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then return false end
	if sg:GetCount()>0 and not sg:IsExists(c1110113.CheckFusionFilter1,1,nil,sg,c) then return false end
	sg:AddCard(c)
	local res=false
	if sg:GetCount()==2 then
		res=(chkf==PLAYER_NONE or Duel.GetLocationCountFromEx(chkf,tp,sg,fc)>0)
		if aux.FCheckAdditional and not aux.FCheckAdditional(tp,sg,fc) then res=false end
	else
		res=mg:IsExists(c1110113.CheckRecursive1,1,sg,mg,sg,exg,tp,fc,PLAYER_NONE)
	end
	sg:RemoveCard(c)
	return res
end
--
function c1110113.con1(e,g,gc,chkfnf)
	if g==nil then return true end
	local sg=Group.CreateGroup()
	local chkf=(chkfnf & 0xff)
	local c=e:GetHandler()
	local tp=c:GetControler()
	local mg=g:Filter(c1110113.allfilter1,nil,c)
	local exg=Duel.GetMatchingGroup(c1110113.exfilter1,tp,LOCATION_EXTRA,0,mg,c)
	mg:Merge(exg)
	if gc then return c1110113.allfilter1(gc,c)
		and c1110113.CheckRecursive1(gc,mg,sg,exg,tp,c,chkf) end
	return mg:IsExists(c1110113.CheckRecursive1,1,sg,mg,sg,exg,tp,c,chkf)
end
--
function c1110113.op1(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local c=e:GetHandler()
	local chkf=(chkfnf & 0xff)
	local mg=eg:Filter(c1110113.allfilter1,nil,c)
	local exg=Duel.GetMatchingGroup(c1110113.exfilter1,tp,LOCATION_EXTRA,0,mg,c)
	mg:Merge(exg)
	local sg=Group.CreateGroup()
	if gc then sg:AddCard(gc) end
	repeat
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g=mg:FilterSelect(tp,c1110113.CheckRecursive1,1,1,sg,mg,sg,exg,tp,c,chkf)
		sg:Merge(g)
	until sg:GetCount()==2
	Duel.SetFusionMaterial(sg)
end
--
function c1110113.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
--
function c1110113.tfilter2(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false) 
		and Duel.GetLocationCountFromEx(tp,tp,e:GetHandler(),c)>0
end
function c1110113.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local lv=c:GetLevel()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return Duel.IsExistingMatchingCard(c1110113.tfilter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,lv)
	end
	e:SetLabel(lv)
	Duel.Release(c,REASON_COST)
end
--
function c1110113.ofilter2(c,e,tp,lv)
	return c:IsLevel(lv) and c:IsType(TYPE_SYNCHRO)
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c1110113.op2(e,tp,eg,ep,ev,re,r,rp)
--
	local c=e:GetHandler()
	local e2_1=Effect.CreateEffect(c)
	e2_1:SetType(EFFECT_TYPE_FIELD)
	e2_1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2_1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e2_1:SetTargetRange(1,0)
	e2_1:SetValue(c1110113.limit2_1)
	if Duel.GetTurnPlayer()==tp then
		e2_1:SetLabel(Duel.GetTurnCount()+1)
	else e2_1:SetLabel(Duel.GetTurnCount()+2) end
	e2_1:SetCondition(c1110113.con2_1)
	e2_1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN,2)
	Duel.RegisterEffect(e2_1,tp)
--
	local lv=e:GetLabel()
	if Duel.GetLocationCountFromEx(tp)<1 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c1110113.ofilter2,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lv)
	if sg:GetCount()<1 then return end
	Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
--
end
--
function c1110113.limit2_1(e,re,tp)
	return re:IsActiveType(TYPE_MONSTER) or (re:IsActiveType(TYPE_TRAP) and re:IsHasType(EFFECT_TYPE_ACTIVATE))
end
function c1110113.con2_1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==e:GetLabel()
end
--
