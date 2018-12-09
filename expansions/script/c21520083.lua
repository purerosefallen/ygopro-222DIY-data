--时间观望者
function c21520083.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunFunRep(c,c21520083.fsfilter1,c21520083.fsfilter2,1,99,true)
	--spsummon condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetValue(c21520083.splimit)
	c:RegisterEffect(e0)
	--special summon rule
	local e00=Effect.CreateEffect(c)
	e00:SetType(EFFECT_TYPE_FIELD)
	e00:SetCode(EFFECT_SPSUMMON_PROC)
	e00:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e00:SetRange(LOCATION_EXTRA)
	e00:SetCondition(c21520083.sprcon)
	e00:SetOperation(c21520083.sprop)
	e00:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(e00)
	--atk & def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MATERIAL_CHECK)
	e1:SetValue(c21520083.matcheck)
	c:RegisterEffect(e1)
	--self destroy
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_SELF_DESTROY)
	e2:SetCondition(c21520083.sdcon)
	c:RegisterEffect(e2)
	--check deck and power up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(21520083,0))
	e3:SetCategory(CATEGORY_RECOVER+CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(TIMING_DAMAGE_STEP+TIMING_DAMAGE_CAL)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c21520083.tg)
	e3:SetOperation(c21520083.operation)
	c:RegisterEffect(e3)
end
function c21520083.fsfilter1(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER) and c:IsLevelAbove(6) and c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_WIND)
end
function c21520083.fsfilter2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsCanBeFusionMaterial() and c:IsType(TYPE_MONSTER)
end
function c21520083.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or se:GetHandler()==e:GetHandler()
end
function c21520083.cfilter(c,tp)
	return ((c:IsLevelAbove(6) and c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsRace(RACE_SPELLCASTER)) or c:IsRace(RACE_SPELLCASTER)) 
		and c:IsType(TYPE_MONSTER) and c:IsCanBeFusionMaterial() and c:IsReleasable() and (c:IsControler(tp) or c:IsFaceup())
end
function c21520083.fcheck(c,sg)
	return c:IsRace(RACE_SPELLCASTER) and c:IsLevelAbove(6) and c:IsType(TYPE_FUSION) and c:IsAttribute(ATTRIBUTE_WIND) and c:IsType(TYPE_MONSTER)
		and c:IsType(TYPE_MONSTER) and sg:FilterCount(c21520083.fcheck2,c)+1==sg:GetCount()
end
function c21520083.fcheck2(c)
	return c:IsRace(RACE_SPELLCASTER) and c:IsType(TYPE_MONSTER)
end
function c21520083.fgoal(c,tp,sg)
	return sg:GetCount()>1 and Duel.GetLocationCountFromEx(tp,tp,sg)>0 and sg:IsExists(c21520083.fcheck,1,nil,sg)
end
function c21520083.fselect(c,tp,mg,sg)
	sg:AddCard(c)
	local res=c21520083.fgoal(c,tp,sg) or mg:IsExists(c21520083.fselect,1,sg,tp,mg,sg)
	sg:RemoveCard(c)
	return res
end
function c21520083.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c21520083.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Group.CreateGroup()
	return mg:IsExists(c21520083.fselect,1,nil,tp,mg,sg)
end
function c21520083.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c21520083.cfilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,tp)
	local sg=Group.CreateGroup()
	while true do
		local cg=mg:Filter(c21520083.fselect,sg,tp,mg,sg)
		if cg:GetCount()==0
			or (c21520083.fgoal(c,tp,sg) and not Duel.SelectYesNo(tp,210)) then break end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=cg:Select(tp,1,1,nil)
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.Release(sg,REASON_COST+REASON_MATERIAL+REASON_FUSION)
end
function c21520083.matcheck(e,c)
	local ct=c:GetMaterialCount()
	local ae=Effect.CreateEffect(c)
	ae:SetType(EFFECT_TYPE_SINGLE)
	ae:SetCode(EFFECT_SET_BASE_ATTACK)
	ae:SetValue(ct*500)
	ae:SetReset(RESET_EVENT+0xff0000)
	c:RegisterEffect(ae)
	local de=ae:Clone()
	de:SetCode(EFFECT_SET_BASE_DEFENSE)
	c:RegisterEffect(de)
end
function c21520083.sdcon(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)~=SUMMON_TYPE_FUSION
end
function c21520083.rfliter(c)
	return c:IsAbleToRemoveAsCost() and c:IsType(TYPE_SPELL)
end
function c21520083.tdfliter(c)
	return c:IsAbleToDeck() and not c:IsStatus(STATUS_DESTROY_CONFIRMED+STATUS_LEAVE_CONFIRMED)
end
function c21520083.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(Duel.GetTurnPlayer(),LOCATION_DECK,0)>0 end
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,0,2000)
	Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,nil,0,0,500)
	Duel.SetOperationInfo(0,CATEGORY_DEFCHANGE,nil,0,0,500)
end
function c21520083.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local player=Duel.GetTurnPlayer()
	local g=Duel.GetFieldGroup(player,LOCATION_DECK,0)
	if g:GetCount()>0 and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
		local op=Duel.SelectOption(c:GetControler(),70,71,72)
		Duel.Hint(HINT_OPSELECTED,tp,op+70)
		local ct=0
		local tc=Duel.GetDecktopGroup(player,1):GetFirst()
		Duel.ConfirmDecktop(player,1)
		Duel.MoveSequence(tc,1)
		while ((op==0 and tc:IsType(TYPE_MONSTER)) or (op==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP))) do
			local ae=Effect.CreateEffect(c)
			ae:SetType(EFFECT_TYPE_SINGLE)
			ae:SetCode(EFFECT_UPDATE_ATTACK)
			ae:SetValue(500)
			ae:SetReset(RESET_EVENT+0xff0000)
			c:RegisterEffect(ae)
			local de=ae:Clone()
			de:SetCode(EFFECT_UPDATE_DEFENSE)
			c:RegisterEffect(de)
			c:SetHint(CHINT_NUMBER,ct+1)
--			c:RegisterFlagEffect(2295831,RESET_CHAIN,EFFECT_FLAG_CLIENT_HINT,1,0,66)
			Duel.BreakEffect()
			if not Duel.SelectYesNo(c:GetControler(),aux.Stringid(21520083,1)) then return end
			--loop
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
			op=Duel.SelectOption(c:GetControler(),70,71,72)
			Duel.Hint(HINT_OPSELECTED,tp,op+70)
			ct=ct+1
			tc=Duel.GetDecktopGroup(player,1):GetFirst()
			Duel.ConfirmDecktop(player,1)
			Duel.MoveSequence(tc,1)
		end
		if not ((op==0 and tc:IsType(TYPE_MONSTER)) or (op==1 and tc:IsType(TYPE_SPELL)) or (opt==2 and tc:IsType(TYPE_TRAP))) then
			Duel.Recover(1-tp,500*ct,REASON_EFFECT)
		end
	end
end
