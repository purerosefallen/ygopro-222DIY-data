--Paganini Caprice Number 24
local m=77777777
local cm=_G["c"..m]
xpcall(function() require("expansions/script/c37564765") end,function() require("script/c37564765") end)
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2)
	Senya.AddSummonMusic(c,m*16,SUMMON_TYPE_LINK)
	c:EnableReviveLimit()
	--f
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16+1)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.MaterialCheck(TYPE_LINK))
	e2:SetCost(Senya.DescriptionCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			return Duel.IsExistingMatchingCard(Card.IsAbleToGraveAsCost,tp,LOCATION_DECK,0,1,nil)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGraveAsCost,tp,LOCATION_DECK,0,1,1,nil)
		Duel.SendtoGrave(g,REASON_COST)
	end))
	e2:SetTarget(aux.TRUE)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ATTACK_ALL)
			e1:SetValue(1)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
		end
	end)
	c:RegisterEffect(e2)
	--s
	local function s_mat_filter(c)
		return c:IsLevelAbove(1) and c:IsAbleToDeck() and not c:IsHasEffect(EFFECT_NECRO_VALLEY)
	end
	local function s_fus_filter(c,e,tp)
		return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	local function s_group_check(g,sg)
		return g:IsExists(Card.IsType,1,nil,TYPE_TUNER) and sg:IsExists(function(c)
			return c:IsLevel(g:GetSum(Card.GetLevel))
		end,1,nil)
	end
	local function synchro_tg(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			if Duel.GetLocationCountFromEx(tp)<=0 then return false end
			local mg=Duel.GetMatchingGroup(s_mat_filter,tp,LOCATION_GRAVE,0,nil)
			local sg=Duel.GetMatchingGroup(s_fus_filter,tp,LOCATION_EXTRA,0,nil,e,tp)
			return Senya.CheckGroup(mg,s_group_check,nil,2,2,sg)
		end
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,2,tp,LOCATION_GRAVE)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16+2)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m-70000)
	e2:SetCondition(cm.MaterialCheck(TYPE_SYNCHRO))
	e2:SetCost(Senya.DescriptionCost())
	e2:SetTarget(synchro_tg)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not synchro_tg(e,tp,eg,ep,ev,re,r,rp,0) then return end
		local mg=Duel.GetMatchingGroup(s_mat_filter,tp,LOCATION_GRAVE,0,nil)
		local sg=Duel.GetMatchingGroup(s_fus_filter,tp,LOCATION_EXTRA,0,nil,e,tp)
		local g=Senya.SelectGroup(tp,CATEGORY_TODECK,mg,s_group_check,nil,2,2,sg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local spg=sg:FilterSelect(tp,Card.IsLevel,1,1,nil,g:GetSum(Card.GetLevel))
		Duel.SendtoDeck(g,nil,2,REASON_EFFECT)
		Duel.BreakEffect()
		Duel.SpecialSummon(spg,0,tp,tp,false,false,POS_FACEUP)
	end)
	c:RegisterEffect(e2)
	--x
	local function x_spfilter(c,e,tp,code)
		return c:GetOriginalCode()==code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
	end
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16+3)
	e2:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m-60000)
	e2:SetProperty(0x14000)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(cm.MaterialCheck(TYPE_FUSION,function(e,tp,eg,ep,ev,re,r,rp)
		local ec=e:GetHandler()
		return eg:IsExists(function(c)
			if c:IsLocation(LOCATION_MZONE) then
				return ec:GetLinkedGroup():IsContains(c)
			else
				return bit.band(ec:GetLinkedZone(c:GetPreviousControler()),bit.lshift(0x1,c:GetPreviousSequence()))~=0
			end
		end,1,nil)
	end))
	e2:SetCost(Senya.DescriptionCost(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return Duel.IsPlayerCanDiscardDeckAsCost(tp,1) end
		local public=Duel.GetDecktopGroup(tp,1):GetFirst():IsFaceup()
		local code=Duel.GetDecktopGroup(tp,1):GetFirst():GetOriginalCode()
		Duel.DiscardDeck(tp,1,REASON_COST)
		e:SetLabel(code|(public and 0x10000000 or 0))
	end))
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<=1 then return false end
			local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
			return tc:IsFacedown() or not tc:IsType(TYPE_MONSTER)
				or Duel.IsExistingMatchingCard(x_spfilter,tp,LOCATION_DECK,0,1,tc,e,tp,tc:GetOriginalCode())
		end
		Duel.SetOperationInfo(0,CATEGORY_ATKCHANGE,e:GetHandler(),1,0,300)
		local info=e:GetLabel()
		local code=info&0xfffffff
		local public=(info&0x10000000)>0
		if not public or Duel.IsExistingMatchingCard(x_spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,code) then
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
		end
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local c=e:GetHandler()
		if c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetValue(300)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			c:RegisterEffect(e1)
			local code=e:GetLabel()&0xfffffff
			if Duel.IsExistingMatchingCard(x_spfilter,tp,LOCATION_DECK,0,1,nil,e,tp,code) then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,x_spfilter,tp,LOCATION_DECK,0,1,1,nil,e,tp,code)
				local tc=g:GetFirst()
				Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE)
				e1:SetCode(EFFECT_DISABLE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1,true)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetValue(RESET_TURN_SET)
				e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e2:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e2,true)
				local e3=Effect.CreateEffect(c)
				e3:SetType(EFFECT_TYPE_SINGLE)
				e3:SetCode(EFFECT_CANNOT_ATTACK)
				e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e3:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e3,true)
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_FIELD)
				e1:SetRange(LOCATION_MZONE)
				e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
				e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetAbsoluteRange(tp,1,0)
				e1:SetTarget(function(e,c,tp,sumtp,sumpos)
					return bit.band(sumtp,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
				end)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				tc:RegisterEffect(e1,true)
				Duel.SpecialSummonComplete()
			end
		end
	end)
	c:RegisterEffect(e2)
	local ex=e2:Clone()
	ex:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(ex)
	--l
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(m*16+4)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetCategory(CATEGORY_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m-5000)
	e2:SetCondition(cm.MaterialCheck(TYPE_XYZ))
	e2:SetCost(Senya.DescriptionCost())
	e2:SetTarget(function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then
			return Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_CONTROL)>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler())
		end
	end)
	e2:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		if not (Duel.GetMZoneCount(tp,nil,tp,LOCATION_REASON_CONTROL)>0 and Duel.IsExistingMatchingCard(nil,tp,LOCATION_MZONE,0,1,e:GetHandler())) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
		local tc=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_MZONE,0,1,1,e:GetHandler()):GetFirst()
		Duel.HintSelection(Group.FromCards(tc))
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOZONE)
		local s=Duel.SelectDisableField(tp,1,LOCATION_MZONE,0,0)
		local nseq=math.log(s,2)
		Duel.MoveSequence(tc,nseq)
		if not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_SPELL+TYPE_TRAP) then
			--[[local zone=(0x0101 << nseq) | (0x01010000 << 4-nseq)
			if seq==1 then
				zone=zone | 0x00400020
			elseif seq==3 then
				zone=zone | 0x00200040
			end]]
			local e4=Effect.CreateEffect(c)
			e4:SetType(EFFECT_TYPE_FIELD)
			e4:SetCode(EFFECT_DISABLE)
			e4:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
			e4:SetTarget(function(e,c)
				local tseq=e:GetLabel()
				local tp=e:GetHandlerPlayer()
				local seq=aux.MZoneSequence(c:GetSequence())
				local rp=c:GetControler()
				if c:IsLocation(LOCATION_SZONE) and c:GetSequence()>4 then return false end
				return (rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)
			end)
			e4:SetReset(RESET_PHASE+PHASE_END)
			e4:SetLabel(aux.MZoneSequence(nseq))
			Duel.RegisterEffect(e4,tp)
			local e5=Effect.CreateEffect(c)
			e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e5:SetCode(EVENT_CHAIN_SOLVING)
			e5:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
				local tseq=e:GetLabel()
				local loc,seq=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_LOCATION,CHAININFO_TRIGGERING_SEQUENCE)
				seq=aux.MZoneSequence(seq)
				if bit.band(loc,LOCATION_ONFIELD)>0
					and ((rp==tp and seq==tseq) or (rp==1-tp and seq==4-tseq)) then
					Duel.NegateEffect(ev)
				end
			end)
			e5:SetReset(RESET_PHASE+PHASE_END)
			e5:SetLabel(aux.MZoneSequence(nseq))
			Duel.RegisterEffect(e5,tp)
		end
	end)
	c:RegisterEffect(e2)
end
function cm.MaterialCheck(t,ex)
	return function(e,...)
		return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK) and e:GetHandler():GetMaterial():IsExists(function(c)
			return c:IsType(t)
		end,1,nil) and (not ex or ex(e,...))
	end
end